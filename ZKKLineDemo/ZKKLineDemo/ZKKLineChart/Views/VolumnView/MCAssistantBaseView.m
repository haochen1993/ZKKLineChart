//
//  MCAssistantBaseView.m
//  ZKKLineDemo
//
//  Created by ZK on 2017/8/25.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import "MCAssistantBaseView.h"
#import "KLineChartView.h"

@interface MCAssistantBaseView ()

@end

@implementation MCAssistantBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
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

- (MCKLineTitleView *)titleView {
    if (!_titleView) {
        _titleView = [MCKLineTitleView titleView];
        _titleView.hidden = true;
        [self addSubview:_titleView];
    }
    _titleView.frame = CGRectMake(self.boxOriginX + 8, 0, self.bounds.size.width, 16);
    return _titleView;
}

- (void)update {
    
}

@end
