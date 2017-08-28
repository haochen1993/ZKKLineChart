//
//  MCStockChartUtil.h
//  ZKKLineDemo
//
//  Created by Zhou Kang on 2017/8/28.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCStockChartUtil : NSObject

/** 将浮点数值转换为小数字符串 默认保留两位小数 */
+ (NSString *)decimalValue:(CGFloat)value;

/** 将浮点数值转换为小数字符串 count为保留的小数个数 */
+ (NSString *)decimalValue:(CGFloat)value count:(NSUInteger)count;

@end
