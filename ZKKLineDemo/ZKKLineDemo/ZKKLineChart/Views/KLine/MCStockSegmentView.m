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

@implementation MCStockSegmentSelectedModel

@end

@interface MCStockSegmentView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *targetBtn;
@property (nonatomic, strong) UIView *popupPanel;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

static const CGFloat kTargetBtnWidth = 60.f;
static const CGFloat kPopupViewHeight = 150.f;
const CGFloat MCStockSegmentViewHeight = 35.f;

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
    self.us_size = CGSizeMake(SCREEN_WIDTH, 200);
    self.us_bottom = self.superview.us_height;
}

- (void)setup {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    _dataSource = @[ @"分时", @"5分", @"30分", @"60分", @"日线" ];
    
    [self setupTargetBtn];
    [self setupCollectionView];
    [self setupPopupPanel];
}

- (void)setupPopupPanel {
    _popupPanel = [UIView new];
    _popupPanel.backgroundColor = BGColor;
    [self insertSubview:_popupPanel atIndex:0];
    _popupPanel.us_size = CGSizeMake(SCREEN_WIDTH, kPopupViewHeight);
    _popupPanel.us_top = self.us_height;
    
    CGFloat btnWidth = 60.f;
    
    UIView *topView = [UIView new];
    [_popupPanel addSubview:topView];
    UILabel *topTitleLabel = [self generateTitleLabel:@"主图"];
    [_popupPanel addSubview:topTitleLabel];
    
    NSArray *topBtnTitles = @[ @"MA", @"BOLL", @"关闭" ];
    for (int i = 0; i < topBtnTitles.count; i ++) {
        UIButton *btn = [self generateBtn:topBtnTitles[i]];
        btn.us_top = CGRectGetMaxY(topTitleLabel.frame);
        btn.us_left = i * btnWidth;
        [btn addTarget:self action:@selector(mainChartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popupPanel addSubview:btn];
    }
    
    UIView *line = [UIView new];
    [_popupPanel addSubview:line];
    line.us_top = _popupPanel.us_size.height * .5;
    line.us_size = CGSizeMake(SCREEN_WIDTH, .5f);
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.4];
    
    UIView *bottomView = [UIView new];
    [_popupPanel addSubview:bottomView];
    UILabel *bottomTitleLabel = [self generateTitleLabel:@"副图"];
    [_popupPanel addSubview:bottomTitleLabel];
    bottomTitleLabel.us_top = _popupPanel.us_size.height * .5;
    
    NSArray *bottomBtnTitles = @[ @"MACD", @"KDJ", @"RSI", @"WR", @"关闭" ];
    for (int i = 0; i < bottomBtnTitles.count; i ++) {
        UIButton *btn = [self generateBtn:bottomBtnTitles[i]];
        btn.us_top = CGRectGetMaxY(bottomTitleLabel.frame);
        btn.us_left = i * btnWidth;
        [btn addTarget:self action:@selector(accessoryChartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popupPanel addSubview:btn];
    }
}

- (UIButton *)generateBtn:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.us_size = CGSizeMake(60, 35);
    [btn setTitleColor:TitleColor_HL forState:UIControlStateSelected];
    return btn;
}

- (UILabel *)generateTitleLabel:(NSString *)title {
    UILabel *label = [UILabel new];
    label.text = title;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.us_size = CGSizeMake(100, 36);
    label.us_left = 15.f;
    return label;
}

- (void)setupTargetBtn {
    _targetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_targetBtn];
    _targetBtn.backgroundColor = GlobalBGColor_Dark;
    [_targetBtn setTitle:@"指标" forState:UIControlStateNormal];
    _targetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _targetBtn.us_size = CGSizeMake(kTargetBtnWidth, MCStockSegmentViewHeight);
    _targetBtn.us_bottom = self.us_height;
    
    [_targetBtn addTarget:self action:@selector(targetBtnClcik) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemWidth = (SCREEN_WIDTH - kTargetBtnWidth) / _dataSource.count;
    layout.itemSize = CGSizeMake(itemWidth, MCStockSegmentViewHeight);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self addSubview:_collectionView];
    _collectionView.backgroundColor = BGColor;
    
    _collectionView.us_size = CGSizeMake(SCREEN_WIDTH - kTargetBtnWidth, MCStockSegmentViewHeight);
    _collectionView.us_left = kTargetBtnWidth;
    _collectionView.us_bottom = self.us_height;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceHorizontal = true;
    _collectionView.showsHorizontalScrollIndicator = false;
    
    [_collectionView registerClass:[MCStockSegmentViewCell class] forCellWithReuseIdentifier:cellID];
}

#pragma mark - Actions

- (void)targetBtnClcik {
    _targetBtn.selected = !_targetBtn.selected;
    
    CGFloat topValue = 0;
    if (_targetBtn.selected) {
        topValue = self.us_height - kPopupViewHeight - MCStockSegmentViewHeight;
    }
    else {
        topValue = self.us_height;
    }
    
    [UIView animateWithDuration:.25 delay:0 options:KeyboardAnimationCurve animations:^{
        _popupPanel.us_top = topValue;
    } completion:nil];
}

- (void)accessoryChartBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    
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
}

- (void)mainChartBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    
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
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MCStockSegmentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell updateWithText:_dataSource[indexPath.item] selectedStyle:indexPath.item == _selectedIndex];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.item;
    [_collectionView reloadData];
    
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
