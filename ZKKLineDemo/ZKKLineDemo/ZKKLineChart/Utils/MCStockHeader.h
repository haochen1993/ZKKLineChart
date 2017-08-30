//
//  MCStockHeader.h
//  ZKKLineDemo
//
//  Created by Zhou Kang on 2017/8/30.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#ifndef MCStockHeader_h
#define MCStockHeader_h

typedef NS_ENUM(NSInteger, MCStockMainChartType) {
    MCStockMainChartTypeMA,
    MCStockMainChartTypeBOLL,
    MCStockMainChartTypeClose,
};

typedef NS_ENUM(NSInteger, MCStockAccessoryChartType) {
    MCStockAccessoryChartTypeMACD,
    MCStockAccessoryChartTypeKDJ,
    MCStockAccessoryChartTypeRSI,
    MCStockAccessoryChartTypeWR,
    MCStockAccessoryChartTypeClose,
};

typedef NS_ENUM(NSInteger, MCStockTargetTimeType) {
    MCStockTargetTimeTypeTiming,
    MCStockTargetTimeTypeMin_5,
    MCStockTargetTimeTypeMin_30,
    MCStockTargetTimeTypeMin_60,
    MCStockTargetTimeTypeDay,
};

typedef NS_ENUM(NSInteger, MCStockSegmentViewSubType) {
    MCStockSegmentViewSubTypeMain,     //!< 主图
    MCStockSegmentViewSubTypeAccessory,//!< 副图
    MCStockSegmentViewSubTypeTime,     //!< 时间轴
};



#endif /* MCStockHeader_h */
