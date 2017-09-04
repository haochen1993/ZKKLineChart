//
//  MCAssistantBaseView.m
//  ZKKLineDemo
//
//  Created by ZK on 2017/8/25.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import "MCAssistantBaseView.h"
#import "MCStockChartView.h"

@interface MCAssistantBaseView ()

@end

@implementation MCAssistantBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.autoFit = false;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
    CGPoint touchPoint = [tapGesture locationInView:self];
    [self.baseChartView showTipBoardWithOuterViewTouchPoint:touchPoint];
}

- (void)showTitleView:(MCKLineModel *)model {
    self.titleView.hidden = false;
    [self.titleView updateWithVolume:model.volume MA5:model.MA7 MA10:model.MA20];
}

- (void)hideTitleView {
    self.titleView.hidden = true;
}

- (MCStockTitleView *)titleView {
    if (!_titleView) {
        _titleView = [MCStockTitleView titleView];
        _titleView.hidden = true;
        [self addSubview:_titleView];
    }
    _titleView.frame = CGRectMake(_stockCtx.leftMargin + 8, 0, self.bounds.size.width, 16);
    return _titleView;
}

- (void)update {
    
}

@end
