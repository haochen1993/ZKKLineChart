//
//  MCStockSegmentView.h
//  ZKKLineDemo
//
//  Created by Zhou Kang on 2017/8/29.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCStockSegmentView;

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

@interface MCStockSegmentSelectedModel: NSObject

@property (nonatomic, assign) MCStockSegmentViewSubType subType;
@property (nonatomic, assign) MCStockTargetTimeType targetTimeType;
@property (nonatomic, assign) MCStockAccessoryChartType accessoryChartType;
@property (nonatomic, assign) MCStockMainChartType mainChartType;

@end

@protocol MCStockSegmentViewDelegate <NSObject>

@optional

- (void)stockSegmentView:(MCStockSegmentView *)segmentView didSelectModel:(MCStockSegmentSelectedModel *)model;

@end

@interface MCStockSegmentView : UIView

@property (nonatomic, weak) id <MCStockSegmentViewDelegate> delegate;

+ (instancetype)segmentView;

@end

extern const CGFloat MCStockSegmentViewHeight;
