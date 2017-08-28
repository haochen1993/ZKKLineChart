//
//  MCStockChartContext.m
//  ZKKLineDemo
//
//  Created by Zhou Kang on 2017/8/28.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import "MCStockChartContext.h"

@implementation MCStockChartContext

+ (instancetype)shareInstance {
    static MCStockChartContext *context_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context_ = [MCStockChartContext new];
    });
    return context_;
}

@end
