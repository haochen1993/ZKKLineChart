//
//  ZKKLineItem.m
//  ChartDemo
//
//  Created by ZhouKang on 2016/12/2.
//  Copyright © 2016年 ZhouKang. All rights reserved.
//

#import "ZKKLineItem.h"

@implementation ZKKLineItem

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"openingPrice": @"open_px",
             @"highestPrice": @"high_px",
             @"lowestPrice": @"low_px",
             @"closingPrice": @"close_px",
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _vol = [dic[@"total_volume_trade"] floatValue] / 10000.f;
    return true;
}

- (NSString *)description {
    NSString *desc = [[NSString alloc] initWithFormat:@"开盘价：%f\n 收盘价：%f\n 最高价：%f\n 最低价：%f\n 成交量：%f\n", self.openingPrice, self.closingPrice, self.highestPrice, self.lowestPrice, self.vol];
    return desc;
}

@end
