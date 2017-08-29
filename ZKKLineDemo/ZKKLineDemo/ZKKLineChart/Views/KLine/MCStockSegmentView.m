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

@end

// ---------

@interface MCStockSegmentView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *targetBtn;
@property (nonatomic, strong) UIView *popupPanel;
@property (nonatomic, copy) NSArray *dataSource;

@end

static const CGFloat kTargetBtnWidth = 60.f;
static const CGFloat kPopupViewHeight = 100.f;
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
    _popupPanel.backgroundColor = [UIColor greenColor];
    [self insertSubview:_popupPanel atIndex:0];
    _popupPanel.us_size = CGSizeMake(SCREEN_WIDTH, kPopupViewHeight);
    _popupPanel.us_top = self.us_height;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_popupPanel addSubview:btn];
    [btn setTitle:@"哈哈" forState:UIControlStateNormal];
    btn.us_size = CGSizeMake(100, 30);
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
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

- (void)test {
    
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MCStockSegmentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.timeLabel.text = _dataSource[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"=---------------");
}

@end
