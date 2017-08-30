//
//  MCStockSegmentView.h
//  ZKKLineDemo
//
//  Created by Zhou Kang on 2017/8/29.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCStockHeader.h"
@class MCStockSegmentView;

@interface MCStockSegmentSelectedModel: NSObject

@property (nonatomic, assign) MCStockSegmentViewSubType subType;
@property (nonatomic, assign) MCStockTargetTimeType targetTimeType;
@property (nonatomic, assign) MCStockAccessoryChartType accessoryChartType;
@property (nonatomic, assign) MCStockMainChartType mainChartType;

@end

@protocol MCStockSegmentViewDelegate <NSObject>

@optional

- (void)stockSegmentView:(MCStockSegmentView *)segmentView didSelectModel:(MCStockSegmentSelectedModel *)model;
- (void)stockSegmentView:(MCStockSegmentView *)segmentView showPopupView:(BOOL)showPopupView;

@end

@interface MCStockSegmentView : UIView

@property (nonatomic, weak) id <MCStockSegmentViewDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isOpening;

+ (instancetype)segmentView;

@end

extern const CGFloat MCStockSegmentViewHeight;
