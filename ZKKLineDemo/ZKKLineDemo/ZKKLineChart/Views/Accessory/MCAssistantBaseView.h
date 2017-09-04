//
//  MCAssistantBaseView.h
//  ZKKLineDemo
//
//  Created by ZK on 2017/8/25.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCStockTitleView.h"
#import "MCStockChartContext.h"
@class MCKLineModel, MCStockChartView;

@interface MCAssistantBaseView : UIView

@property (nonatomic, strong) MCStockTitleView *titleView;

@property (nonatomic, assign) NSInteger startDrawIndex; //!< 取值位置

@property (nonatomic, assign) NSInteger numberOfDrawCount; //!< 绘制个数

@property (nonatomic, assign) BOOL autoFit;

//默认 YES
@property (nonatomic, assign) BOOL gestureEnable;

@property (nonatomic, strong) NSArray <MCKLineModel *> *data;

@property (nonatomic, weak) MCStockChartView *baseChartView;

- (void)update;

- (void)showTitleView:(MCKLineModel *)model;

- (void)hideTitleView;

@end
