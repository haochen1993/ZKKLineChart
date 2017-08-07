//
//  KLineListTransformer.h
//  ChartDemo
//
//  Created by ZhouKang on 16/8/12.
//  Copyright © 2016年 ZhouKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GApiBaseManager.h"

// 数据
extern NSString *const kCandlestickChartsContext;

// 日期
extern NSString *const kCandlestickChartsDate;

// 最高价
extern NSString *const kCandlestickChartsMaxHigh;

// 最低价
extern NSString *const kCandlestickChartsMinLow;

// 成交量
extern NSString *const kCandlestickChartsVol;

/////////////////////////////////////////////////////////

// RSV9
extern NSString *const kCandlestickChartsRSV9;

// KDJ
extern NSString *const kCandlestickChartsKDJ;

// MACD
extern NSString *const kCandlestickChartsMACD;

// RSI
extern NSString *const kCandlestickChartsRSI;

// BOLL
extern NSString *const kCandlestickChartsBOLL;

// DMA
extern NSString *const kCandlestickChartsDMA;

// CCI
extern NSString *const kCandlestickChartsCCI;

// 威廉指数
extern NSString *const kCandlestickChartsWR;

// BIAS
extern NSString *const kCandlestickChartsBIAS;

/**
 *  extern key 可修改为Entity
 */
@interface KLineListTransformer : NSObject <GApiBaseManagerCallBackDataTransformer>

@end
