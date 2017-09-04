//
//  MCStockChartContext.h
//  ZKKLineDemo
//
//  Created by Zhou Kang on 2017/8/28.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCStockChartUtil.h"
#import "MCStockHeader.h"

#define _stockCtx [MCStockChartContext shareInstance]

@interface MCStockSegmentSelectedModel: NSObject

@property (nonatomic, assign) MCStockSegmentViewSubType subType;
@property (nonatomic, assign) MCStockTargetTimeType targetTimeType;
@property (nonatomic, assign) MCStockAccessoryChartType accessoryChartType;
@property (nonatomic, assign) MCStockMainChartType mainChartType;

@end

// ------

@interface MCStockChartContext : NSObject

+ (instancetype)shareInstance;
@property (nonatomic, assign) CGFloat KLineWidth;
@property (nonatomic, assign) CGFloat KLinePadding;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;

@property (nonatomic, strong) MCStockSegmentSelectedModel *selectedModel;

@end
