//
//  MCStockChartUtil.m
//  ZKKLineDemo
//
//  Created by Zhou Kang on 2017/8/28.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import "MCStockChartUtil.h"

@implementation MCStockChartUtil

+ (NSString *)decimalValue:(CGFloat)value {
    return [self decimalValue:value count:2];
}

+ (NSString *)decimalValue:(CGFloat)value count:(NSUInteger)count {
    NSString *str = nil;
    NSString *strFormat = [NSString stringWithFormat:@"%%.%zdf", count];
    str = [NSString stringWithFormat:strFormat, value];
    return str;
}

@end
