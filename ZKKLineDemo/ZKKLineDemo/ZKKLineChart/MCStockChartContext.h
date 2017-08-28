//
//  MCStockChartContext.h
//  ZKKLineDemo
//
//  Created by Zhou Kang on 2017/8/28.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCStockChartUtil.h"

#define _stockContext [MCStockChartContext shareInstance]

@interface MCStockChartContext : NSObject

+ (instancetype)shareInstance;

@end
