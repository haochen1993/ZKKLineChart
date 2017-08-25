//
//  TYBarChartView.h
//  CandlerstickCharts
//
//  Created by ZhouKang on 16/8/11.
//  Copyright © 2016年 liuxd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCKLineModel.h"

@interface KLineChartView : UIView

/************************************************************************************/
/*                                          |                                       */
/*                                      topMargin                                   */
/*                                          |                                       */
/*                    *------------------------------------------*                  */
/*                    |                                          |                  */
/*                    |                                          |                  */
/* <-  leftMargin   ->|                    k线图                  | <- leftMargin -> */
/*                    |                                          |                  */
/*                    |                                          |                  */
/*                    *------------------------------------------*      -           */
/*                                                                      |           */
/*                                                                      |           */
/*                                                                      |           */
/***********************************************************************|************/
/*                                   showBarChart = YES                 |           */
/****************************************************************** bottomMargin ****/
/*                    *------------------------------------------*      |           */
/*                    |                                          |      |           */
/*                    |                    柱形图                 |      |           */
/*                    |                                          |      |           */
/*                    *------------------------------------------*      _           */
/************************************************************************************/

@property (nonatomic, assign) CGFloat topMargin; //!< 内容距离父试图顶部高度

@property (nonatomic, assign) CGFloat leftMargin; //!< 内容距离父试图左边距离

@property (nonatomic, assign) CGFloat rightMargin; //!< 内容距离父试图右边距离

@property (nonatomic, assign) CGFloat bottomMargin; //!< 内容距离父试图底部距离

@property (nonatomic, strong) UIColor *positiveLineColor; //!< 阳线颜色(negative line)

@property (nonatomic, strong) UIColor *negativeLineColor; //!< 阴线颜色

@property (nonatomic, assign) BOOL zoomEnable; //!< 默认可以放大缩小

@property (nonatomic, assign) BOOL showAvgLine; //!< 默认显示均线

@property (nonatomic, assign) BOOL showBarChart; //!< 显示柱形图，默认显示

@property (nonatomic, assign) BOOL autoFit; //!< YES表示：Y坐标的值根据视图中呈现的k线图的最大值最小值变化而变化；NO表示：Y坐标是所有数据中的最大值最小值，不管k线图呈现如何都不会变化。默认YES

@property (nonatomic, strong) NSArray <NSNumber *> *MAValues; //!< 均线个数（默认ma5, ma10, ma20）

@property (nonatomic, strong) NSArray<UIColor *> *MAColors; //!< 均线颜色值 (默认 HexRGB(0x019FFD)、HexRGB(0xFF9900)、HexRGB(0xFF00FF))

@property (nonatomic, assign) BOOL landscapeMode;

/**
 *  动态更新显示最新, 默认不开启。
 *
 *  注意⚠️
 1. 有新数据过来，新数据会呈现高亮状态提示为最新数据
 2. 开启，有新数据过来，会以最新数据显示为准绘制在UI；优先级优于用户操作；忽略用户操作的结果。
 3. 不开启，优先级低于手势，处理完手势，才会处理最新数据，用户的操作为准。
 */
@property (nonatomic, assign) BOOL dynamicUpdateIsNew;

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

- (void)showTipBoardWithTouchPoint:(CGPoint)point;

@end
