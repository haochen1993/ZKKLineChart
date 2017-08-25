//
//  VolumnView.h
//  ChartDemo
//
//  Created by ZhouKang on 2016/11/17.
//  Copyright © 2016年 ZhouKang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCKLineModel;

@interface MCAccessoryView : UIView

/*
 * 边框开始坐标点
 */
@property (nonatomic, assign) float boxOriginX;

/*
 *  边框距离右边距离
 */
@property (nonatomic, assign) float boxRightMargin;

/**
 *  k线图宽度
 */
@property (nonatomic, assign) CGFloat kLineWidth;

/**
 *  k线图间距
 */
@property (nonatomic, assign) CGFloat linePadding;

/**
 *  y坐标轴字体
 */
@property (nonatomic, strong) UIFont *yAxisTitleFont;

/**
 *  y坐标轴标题颜色
 */
@property (nonatomic, strong) UIColor *yAxisTitleColor;

/**
 *  坐标轴边框颜色
 */
@property (nonatomic, strong) UIColor *axisShadowColor;

/**
 *  坐标轴边框宽度
 */
@property (nonatomic, assign) CGFloat axisShadowWidth;

/**
 *  交易量阳线颜色
 */
@property (nonatomic, strong) UIColor *positiveVolColor;

/**
 *  交易量阴线颜色
 */
@property (nonatomic, strong) UIColor *negativeVolColor;

/**
 *  分割线大小
 */
@property (nonatomic, assign) CGFloat separatorWidth;

/**
 *  分割线颜色
 */
@property (nonatomic, strong) UIColor *separatorColor;

/*
 *  取值位置
 */
@property (nonatomic, assign) NSInteger startDrawIndex;

/*
 *  绘制个数
 */
@property (nonatomic, assign) NSInteger numberOfDrawCount;

//默认 YES
@property (nonatomic, assign) BOOL gestureEnable;

- (void)showTitleView:(MCKLineModel *)model;
- (void)hideTitleView;

@property (nonatomic, strong) NSArray <MCKLineModel *> *data;

- (void)update;

@end

