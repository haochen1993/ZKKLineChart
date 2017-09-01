//
//  MCStockSegmentView.m
//  ZKKLineDemo
//
//  Created by Zhou Kang on 2017/8/29.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import "MCStockSegmentView.h"
#import "UIView+Addition.h"
#import "MacroToolHeader.h"
#import <Masonry.h>

#define TitleColor_Nor  HexColor(0x434b56)
#define TitleColor_HL   HexColor(0x2187c9)
#define BGColor         HexColor(0x20232b)

static NSString *cellID = @"MCStockSegmentViewCell";

@interface MCStockSegmentViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *flagImageView;

- (void)updateWithText:(NSString *)text selectedStyle:(BOOL)isSelectedStyle;

@end

@implementation MCStockSegmentViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    _timeLabel.frame = self.bounds;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = TitleColor_Nor;
}

- (void)updateWithText:(NSString *)text selectedStyle:(BOOL)isSelectedStyle {
    _timeLabel.text = text;
    _timeLabel.textColor = isSelectedStyle ? TitleColor_HL : TitleColor_Nor;
}

@end

// ---------

@interface MCStockSegmentView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *targetBtn;
@property (nonatomic, strong) UIView *popupPanel;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, strong) MCStockSegmentSelectedModel *selectedModel;
@property (nonatomic, strong) UIButton *selectedMainChartBtn;
@property (nonatomic, strong) UIButton *selectedAccessoryChartBtn;
@property (nonatomic, strong) MASConstraint *popupPanelTop;

@end

static const CGFloat kTargetBtnWidth = 60.f;
static const CGFloat kPopupViewHeight = 150.f;
const CGFloat MCStockSegmentCellHeight = 35.f;
const CGFloat MCStockSegmentTotalHeight = 200.f;

@implementation MCStockSegmentView

+ (instancetype)segmentView {
    return [self new];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_collectionView reloadData];
}

- (void)setup {
    self.us_width = SCREEN_WIDTH;
    
    _selectedModel = [MCStockSegmentSelectedModel new];
    _selectedModel.mainChartType = MCStockMainChartTypeMA;
    _selectedModel.accessoryChartType = MCStockAccessoryChartTypeMACD;
    _selectedModel.targetTimeType = MCStockTargetTimeTypeMin_30;
    
    _dataSource = @[ @"分时", @"5分", @"30分", @"60分", @"日线" ];
    
    [self setupTargetBtn];
    [self setupCollectionView];
    [self setupPopupPanel];
}

- (void)setupPopupPanel {
    _popupPanel = [UIView new];
    _popupPanel.backgroundColor = BGColor;
    [self insertSubview:_popupPanel atIndex:0];
    
    [_popupPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kPopupViewHeight);
        _popupPanelTop = make.top.mas_equalTo(MCStockSegmentTotalHeight);
    }];
    
    CGFloat btnWidth = 60.f;
    
    UILabel *topTitleLabel = [self generateTitleLabel:@"主图"];
    [_popupPanel addSubview:topTitleLabel];
    [topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 36));
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(15);
    }];
    
    NSArray *topBtnTitles = @[ @"MA", @"BOLL", @"关闭" ];
    for (int i = 0; i < topBtnTitles.count; i ++) {
        UIButton *btn = [self generateBtn:topBtnTitles[i]];
        [btn addTarget:self action:@selector(mainChartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popupPanel addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(btnWidth, 35));
            make.left.mas_equalTo(i * btnWidth);
            make.top.mas_equalTo(topTitleLabel.mas_bottom);
        }];
        
        if (i == 0) {
            [self mainChartBtnClick:btn];
        }
    }
    
    UIView *line = [UIView new];
    [_popupPanel addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(kPopupViewHeight * .5);
        make.height.mas_equalTo(.5);
    }];
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.4];
    
    UILabel *bottomTitleLabel = [self generateTitleLabel:@"副图"];
    [_popupPanel addSubview:bottomTitleLabel];
    [bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kPopupViewHeight * .5);
        make.size.mas_equalTo(CGSizeMake(100, 36));
        make.left.mas_equalTo(15);
    }];
    
    NSArray *bottomBtnTitles = @[ @"MACD", @"KDJ", @"RSI", @"WR", @"关闭" ];
    for (int i = 0; i < bottomBtnTitles.count; i ++) {
        UIButton *btn = [self generateBtn:bottomBtnTitles[i]];
        [btn addTarget:self action:@selector(accessoryChartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popupPanel addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(btnWidth, 35));
            make.left.mas_equalTo(i * btnWidth);
            make.top.mas_equalTo(bottomTitleLabel.mas_bottom);
        }];
        
        if (i == 0) {
            [self accessoryChartBtnClick:btn];
        }
    }
}

- (UIButton *)generateBtn:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:TitleColor_HL forState:UIControlStateSelected];
    return btn;
}

- (UILabel *)generateTitleLabel:(NSString *)title {
    UILabel *label = [UILabel new];
    label.text = title;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    return label;
}

- (void)setupTargetBtn {
    _targetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_targetBtn];
    _targetBtn.backgroundColor = GlobalBGColor_Dark;
    [_targetBtn setTitle:@"指标" forState:UIControlStateNormal];
    _targetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [_targetBtn addTarget:self action:@selector(targetBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [_targetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kTargetBtnWidth, MCStockSegmentCellHeight));
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.us_height);
    }];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    [self addSubview:_collectionView];
    _collectionView.backgroundColor = BGColor;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceHorizontal = true;
    _collectionView.showsHorizontalScrollIndicator = false;
    
    [_collectionView registerClass:[MCStockSegmentViewCell class] forCellWithReuseIdentifier:cellID];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kTargetBtnWidth);
        make.bottom.mas_equalTo(self.us_height);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(MCStockSegmentCellHeight);
    }];
}

#pragma mark - Actions

- (void)targetBtnClcik {
    _isOpening = !_isOpening;
    
    CGFloat topValue = 0;
    if (_isOpening) {
        topValue = MCStockSegmentTotalHeight - kPopupViewHeight - MCStockSegmentCellHeight;
    }
    else {
        topValue = MCStockSegmentTotalHeight;
    }
    
    [_popupPanelTop uninstall];
    [_popupPanel mas_updateConstraints:^(MASConstraintMaker *make) {
        _popupPanelTop = make.top.mas_equalTo(topValue);
    }];
    [UIView animateWithDuration:.2 delay:0 options:KeyboardAnimationCurve animations:^{
        [self layoutIfNeeded];
    } completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(stockSegmentView:showPopupView:)]) {
        [self.delegate stockSegmentView:self showPopupView:_isOpening];
    }
}

- (void)accessoryChartBtnClick:(UIButton *)btn {
    _selectedAccessoryChartBtn.selected = false;
    btn.selected = true;
    _selectedAccessoryChartBtn = btn;
    
    MCStockSegmentSelectedModel *model = [MCStockSegmentSelectedModel new];
    model.subType = MCStockSegmentViewSubTypeAccessory;
    
    if ([btn.currentTitle isEqualToString:@"MACD"]) {
        model.accessoryChartType = MCStockAccessoryChartTypeMACD;
    }
    else if ([btn.currentTitle isEqualToString:@"KDJ"]) {
        model.accessoryChartType = MCStockAccessoryChartTypeKDJ;
    }
    else if ([btn.currentTitle isEqualToString:@"RSI"]) {
        model.accessoryChartType = MCStockAccessoryChartTypeRSI;
    }
    else if ([btn.currentTitle isEqualToString:@"WR"]) {
        model.accessoryChartType = MCStockAccessoryChartTypeWR;
    }
    else if ([btn.currentTitle isEqualToString:@"关闭"]) {
        model.accessoryChartType = MCStockAccessoryChartTypeClose;
    }
    if ([self.delegate respondsToSelector:@selector(stockSegmentView:didSelectModel:)]) {
        [self.delegate stockSegmentView:self didSelectModel:model];
    }
    [self hidePopupView];
}

- (void)mainChartBtnClick:(UIButton *)btn {
    _selectedMainChartBtn.selected = false;
    btn.selected = true;
    _selectedMainChartBtn = btn;
    
    MCStockSegmentSelectedModel *model = [MCStockSegmentSelectedModel new];
    model.subType = MCStockSegmentViewSubTypeMain;
    
    if ([btn.currentTitle isEqualToString:@"MA"]) {
        model.mainChartType = MCStockMainChartTypeMA;
    }
    else if ([btn.currentTitle isEqualToString:@"BOLL"]) {
        model.mainChartType = MCStockMainChartTypeBOLL;
    }
    else if ([btn.currentTitle isEqualToString:@"关闭"]) {
        model.mainChartType = MCStockMainChartTypeClose;
    }
    if ([self.delegate respondsToSelector:@selector(stockSegmentView:didSelectModel:)]) {
        [self.delegate stockSegmentView:self didSelectModel:model];
    }
    [self hidePopupView];
}

- (void)hidePopupView {
    [self targetBtnClcik];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MCStockSegmentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell updateWithText:_dataSource[indexPath.item] selectedStyle:indexPath.item == _selectedModel.targetTimeType];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    CGFloat itemWidth = (self.us_width - kTargetBtnWidth) / _dataSource.count;
    size = CGSizeMake(itemWidth, MCStockSegmentCellHeight);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_collectionView reloadData];
    _selectedModel.targetTimeType = indexPath.item;
    
    MCStockSegmentSelectedModel *model = [MCStockSegmentSelectedModel new];
    model.subType = MCStockSegmentViewSubTypeTime;
    
    switch (indexPath.item) {
        case 0: {
            model.targetTimeType = MCStockTargetTimeTypeTiming;
        } break;
        case 1: {
            model.targetTimeType = MCStockTargetTimeTypeMin_5;
        } break;
        case 2: {
            model.targetTimeType = MCStockTargetTimeTypeMin_30;
        } break;
        case 3: {
            model.targetTimeType = MCStockTargetTimeTypeMin_60;
        } break;
        case 4: {
            model.targetTimeType = MCStockTargetTimeTypeDay;
        } break;
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(stockSegmentView:didSelectModel:)]) {
        [self.delegate stockSegmentView:self didSelectModel:model];
    }
}

@end
