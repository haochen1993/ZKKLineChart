//
//  MCAssistantBaseView.h
//  ZKKLineDemo
//
//  Created by ZK on 2017/8/25.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCKLineTitleView.h"
@class MCKLineModel, KLineChartView;

@interface MCAssistantBaseView : UIView

@property (nonatomic, strong) MCKLineTitleView *titleView;

@property (nonatomic, assign) float boxOriginX; //!< 边框开始坐标点

@property (nonatomic, assign) float boxRightMargin; //!< 边框距离右边距离

@property (nonatomic, assign) CGFloat kLineWidth; //!< k线图宽度

@property (nonatomic, assign) CGFloat linePadding; //!< k线图间距

@property (nonatomic, strong) UIFont *yAxisTitleFont; //!< y坐标轴字体

@property (nonatomic, strong) UIColor *yAxisTitleColor; //!< y坐标轴标题颜色

@property (nonatomic, strong) UIColor *axisShadowColor; //!< 坐标轴边框颜色

@property (nonatomic, assign) CGFloat axisShadowWidth; //!< 坐标轴边框宽度

@property (nonatomic, strong) UIColor *positiveVolColor; //!< 交易量阳线颜色

@property (nonatomic, strong) UIColor *negativeVolColor; //!< 交易量阴线颜色

@property (nonatomic, assign) CGFloat separatorWidth; //!< 分割线宽度

@property (nonatomic, strong) UIColor *separatorColor; //!< 分割线颜色

@property (nonatomic, assign) NSInteger startDrawIndex; //!< 取值位置

@property (nonatomic, assign) NSInteger numberOfDrawCount; //!< 绘制个数

@property (nonatomic, assign) BOOL autoFit;

//默认 YES
@property (nonatomic, assign) BOOL gestureEnable;

@property (nonatomic, strong) NSArray <MCKLineModel *> *data;

@property (nonatomic, weak) KLineChartView *baseChartView;

- (void)update;

- (void)showTitleView:(MCKLineModel *)model;

- (void)hideTitleView;

@end
