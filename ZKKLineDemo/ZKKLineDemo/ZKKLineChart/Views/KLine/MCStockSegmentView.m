//
//  MCStockSegmentView.m
//  ZKKLineDemo
//
//  Created by Zhou Kang on 2017/8/29.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import "MCStockSegmentView.h"
#import "UIView+Addition.h"
#import "ACMacros.h"

@interface MCStockSegmentView ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *targetBtn;
@property (nonatomic, strong) UIView *popupPanel;

@end

static const CGFloat kTargetBtnWidth = 60.f;
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
    [self setupTargetBtn];
    [self setupCollectionView];
    [self setupPopupPanel];
}

- (void)setupPopupPanel {
    _popupPanel = [UIView new];
    _popupPanel.backgroundColor = [UIColor greenColor];
    [self insertSubview:_popupPanel atIndex:0];
    _popupPanel.us_size = CGSizeMake(SCREEN_WIDTH, 100);
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
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor redColor];
    
    _collectionView.us_size = CGSizeMake(SCREEN_WIDTH - kTargetBtnWidth, MCStockSegmentViewHeight);
    _collectionView.us_left = kTargetBtnWidth;
    _collectionView.us_bottom = self.us_height;
}

#pragma mark - Actions

- (void)targetBtnClcik {
    NSLog(@"-----");
    
    [UIView animateWithDuration:.25 delay:0 options:KeyboardAnimationCurve animations:^{
        _popupPanel.us_top = self.us_height - 100 - MCStockSegmentViewHeight;
    } completion:nil];
}

- (void)test {
    NSLog(@"dfgdgfgdf");
}

@end
