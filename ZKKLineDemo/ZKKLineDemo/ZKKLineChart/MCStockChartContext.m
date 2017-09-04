//
//  MCStockChartContext.m
//  ZKKLineDemo
//
//  Created by Zhou Kang on 2017/8/28.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import "MCStockChartContext.h"

@implementation MCStockSegmentSelectedModel

@end

// ------

@implementation MCStockChartContext

+ (instancetype)shareInstance {
    static MCStockChartContext *context_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context_ = [MCStockChartContext new];
        [context_ setup];
    });
    return context_;
}

- (void)setup {
    [self initData];
    [self setupSelectedModel];
}

- (void)setupSelectedModel {
    _selectedModel = [MCStockSegmentSelectedModel new];
    _selectedModel.mainChartType = MCStockMainChartTypeMA;
    _selectedModel.accessoryChartType = MCStockAccessoryChartTypeMACD;
    _selectedModel.targetTimeType = MCStockTargetTimeTypeMin_30;
}

- (void)initData {
    _KLineWidth = 4.f;
    _KLinePadding = 2.f;
    _leftMargin = 5.f;
    _rightMargin = 2.f;
}

//_stockCtx.KLineWidth = MIN(MAX(kLineWidth, self.minKLineWidth), self.maxKLineWidth);

@end
