//
//  KLineChartView.h
//  ZKKLineDemo
//
//  Created by ZhouKang on 17/8/11.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCKLineModel.h"
#import "MCStockHeader.h"
@class MCStockChartView;

@protocol MCStockChartViewDelegate <NSObject>

@optional
- (void)stockChartView:(MCStockChartView *)stockChartView didSelectTargetTime:(MCStockTargetTimeType)targetTimeType;

@end

@interface MCStockChartView : UIView

@property (nonatomic, assign) CGFloat topMargin; //!< 内容距离父试图顶部高度

@property (nonatomic, assign) BOOL zoomEnable; //!< 默认可以放大缩小

@property (nonatomic, assign) BOOL showAvgLine; //!< 默认显示均线

@property (nonatomic, assign) BOOL showBarChart; //!< 显示柱形图，默认显示

@property (nonatomic, assign) BOOL autoFit; //!< YES表示：Y坐标的值根据视图中呈现的k线图的最大值最小值变化而变化；NO表示：Y坐标是所有数据中的最大值最小值，不管k线图呈现如何都不会变化。默认YES

@property (nonatomic, strong) NSArray <NSNumber *> *MAValues; //!< 均线个数（默认ma5, ma10, ma20）

@property (nonatomic, strong) NSArray<UIColor *> *MAColors; //!< 均线颜色值 (默认 HexRGB(0x019FFD)、HexRGB(0xFF9900)、HexRGB(0xFF00FF))

@property (nonatomic, assign) BOOL landscapeMode;

@property (nonatomic, weak) id <MCStockChartViewDelegate> delegate;

- (void)drawChartWithDataSource:(NSArray <MCKLineModel *> *)dataSource;

// 更新数据
- (void)updateChartWithOpen:(CGFloat)open
                      close:(CGFloat)close
                       high:(CGFloat)high
                        low:(CGFloat)low
                       date:(NSString *)date
                      isNew:(BOOL)isNew;

- (void)updateChartWithOpen:(CGFloat)open
                      close:(CGFloat)close
                       high:(CGFloat)high
                        low:(CGFloat)low
                       date:(NSString *)date
                        mas:(NSArray *)mas
                      isNew:(BOOL)isNew;

- (void)clear;

- (void)showTipBoardWithOuterViewTouchPoint:(CGPoint)touchPoint;

@end
