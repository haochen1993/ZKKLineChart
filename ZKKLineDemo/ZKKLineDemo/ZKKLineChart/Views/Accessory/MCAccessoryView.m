//
//  VolumnView.m
//  ChartDemo
//
//  Created by ZhouKang on 2016/11/17.
//  Copyright © 2016年 ZhouKang. All rights reserved.
//

#import "MCAccessoryView.h"
#import "MCKLineModel.h"
#import "UIBezierPath+curved.h"
#import "MCStockChartUtil.h"
#import "NSString+Common.h"

@interface MCAccessoryView ()

@property (nonatomic) CGFloat highestValue;
@property (nonatomic) CGFloat lowestValue;
@property (nonatomic, copy) NSArray <NSNumber *> *MAValues;
@property (nonatomic, copy) NSArray <UIColor *> *MAColors;

@end

static const CGFloat kVerticalMargin = 12.f;

@implementation MCAccessoryView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _MAValues = [NSArray array];
    _MAColors = [NSArray array];
    
    _highestValue = -MAXFLOAT;
    _lowestValue = MAXFLOAT;
    self.accessoryChartType = MCStockAccessoryChartTypeMACD;
}

- (void)setAccessoryChartType:(MCStockAccessoryChartType)accessoryChartType {
    _accessoryChartType = accessoryChartType;
    switch (accessoryChartType) {
        case MCStockAccessoryChartTypeMACD: {
            _MAValues = @[ @0, @0 ];
            _MAColors = @[ [UIColor whiteColor], [UIColor yellowColor] ];
        }  break;
        case MCStockAccessoryChartTypeKDJ: {
            _MAValues = @[ @0, @0, @0 ];
            _MAColors = @[ [UIColor whiteColor], [UIColor yellowColor], [UIColor purpleColor] ];
        }  break;
        case MCStockAccessoryChartTypeRSI: {
            _MAValues = @[ @6, @12, @24 ];
            _MAColors = @[ [UIColor whiteColor], [UIColor yellowColor], [UIColor purpleColor] ];
        }  break;
        case MCStockAccessoryChartTypeWR: {
            
        }  break;
        case MCStockAccessoryChartTypeClose: {
            
        }  break;
    }
}

// overrite
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self drawAxis];
    [self drawChart];
    [self drawMALine];
}

- (void)drawMALine {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.f);
    for (int i = 0; i < _MAValues.count; i ++) {
        CGContextSetStrokeColorWithColor(context, _MAColors[i].CGColor);
        CGPathRef path = [self movingAvgGraphPathForContextAtIndex:i];
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
}

- (CGFloat)calcValuePerHeightUnit {
    CGFloat unitValue = (_highestValue - _lowestValue) / (self.frame.size.height - kVerticalMargin * 2);
    return unitValue ?: 1.f;
}

- (CGPathRef)movingAvgGraphPathForContextAtIndex:(NSInteger)index {
    UIBezierPath *path = nil;
    CGFloat xAxisValue = self.boxOriginX + 0.5*self.kLineWidth + self.linePadding;
    CGFloat unitValue = [self calcValuePerHeightUnit];
    // 均线个数
    NSInteger maLength = [self.MAValues[index] integerValue];
    
    NSArray *drawArrays = [self.data subarrayWithRange:NSMakeRange(self.startDrawIndex, self.numberOfDrawCount)];
    for (int i = 0; i < drawArrays.count; i ++) {
        MCKLineModel *item = drawArrays[i];
        
        CGFloat MAValue = 0;
        
        switch (_accessoryChartType) {
            case MCStockAccessoryChartTypeMACD: {
                if (index == 0) {
                    MAValue = item.DEA;
                }
                else if (index == 1) {
                    MAValue = item.DIF;
                }
            } break;
            case MCStockAccessoryChartTypeKDJ: {
                if (index == 0) {
                    MAValue = item.KDJ_K;
                }
                else if (index == 1) {
                    MAValue = item.KDJ_D;
                }
                else if (index == 2) {
                    MAValue = item.KDJ_J;
                }
            } break;
            case MCStockAccessoryChartTypeRSI: {
                if (index == 0) {
                    MAValue = item.RSI_6;
                }
                else if (index == 1) {
                    MAValue = item.RSI_12;
                }
                else if (index == 2) {
                    MAValue = item.RSI_24;
                }
            } break;
            case MCStockAccessoryChartTypeWR: {
                
            } break;
            case MCStockAccessoryChartTypeClose: {
                
            } break;
        }
        // 不足均线个数，则不需要获取该段均线数据(例如: 均5，个数小于5个，则不需要绘制前四均线，...)
        BOOL notEnoughToDraw = [self.data indexOfObject:item] < maLength - 1;
        if ((notEnoughToDraw && maLength) || !MAValue) {
            xAxisValue += self.kLineWidth + self.linePadding;
            continue;
        }
        CGFloat deltaToBottomAxis = (MAValue - _lowestValue) / unitValue;
        CGFloat yAxisValue = self.bounds.size.height - (deltaToBottomAxis ?: 1) - kVerticalMargin;
        CGPoint maPoint = CGPointMake(xAxisValue, yAxisValue);
        if (!path) {
            path = [UIBezierPath bezierPath];
            [path moveToPoint:maPoint];
        }
        else {
            [path addLineToPoint:maPoint];
        }
        xAxisValue += self.kLineWidth + self.linePadding;
    }
    //圆滑
    path = [path mc_smoothedPathWithGranularity:15];
    return path.CGPath;
}

#pragma mark - public methods

- (void)update {
    [self resetMaxAndMin];
    [self setNeedsDisplay];
}

- (void)showTitleView:(MCKLineModel *)model {
    self.titleView.hidden = false;
    [self.titleView updateWithMACD:model.MACD DIF:model.DIF DEA:model.DEA];
}

#pragma mark - private methods

- (void)resetMaxAndMin {
    _highestValue = CGFLOAT_MIN;
    _lowestValue = CGFLOAT_MAX;
    
    NSArray *subValues = [self.data subarrayWithRange:NSMakeRange(self.startDrawIndex, self.numberOfDrawCount)];
    NSArray *volums = self.autoFit ? subValues : self.data;
    for (MCKLineModel *model in volums) {
        switch (_accessoryChartType) {
            case MCStockAccessoryChartTypeMACD:{
                [self resetWhenTypeMACDWithModel:model];
            } break;
            case MCStockAccessoryChartTypeKDJ:{
                [self resetWhenTypeKDJWithModel:model];
            } break;
            case MCStockAccessoryChartTypeRSI:{
                [self resetWhenTypeRSIWithModel:model];
            } break;
            case MCStockAccessoryChartTypeWR:{
                
            } break;
            case MCStockAccessoryChartTypeClose:{
                
            } break;
        }
    }
}

- (void)resetWhenTypeRSIWithModel:(MCKLineModel *)model {
    if (model.RSI_6) {
        _lowestValue = MIN(_lowestValue, model.RSI_6);
        _highestValue = MAX(_highestValue, model.RSI_6);
    }
    if (model.RSI_12) {
        _lowestValue = MIN(_lowestValue, model.RSI_12);
        _highestValue = MAX(_highestValue, model.RSI_12);
    }
    if (model.RSI_24) {
        _lowestValue = MIN(_lowestValue, model.RSI_24);
        _highestValue = MAX(_highestValue, model.RSI_24);
    }
}

- (void)resetWhenTypeKDJWithModel:(MCKLineModel *)model {
    if (model.KDJ_K) {
        _lowestValue = MIN(_lowestValue, model.KDJ_K);
        _highestValue = MAX(_highestValue, model.KDJ_K);
    }
    if (model.KDJ_D) {
        _lowestValue = MIN(_lowestValue, model.KDJ_D);
        _highestValue = MAX(_highestValue, model.KDJ_D);
    }
    if (model.KDJ_J) {
        _lowestValue = MIN(_lowestValue, model.KDJ_J);
        _highestValue = MAX(_highestValue, model.KDJ_J);
    }
}

- (void)resetWhenTypeMACDWithModel:(MCKLineModel *)model {
    if(model.DIF) {
        _lowestValue = MIN(_lowestValue, model.DIF);
        _highestValue = MAX(_highestValue, model.DIF);
    }
    if(model.DEA) {
        _lowestValue = MIN(_lowestValue, model.DEA);
        _highestValue = MAX(_highestValue, model.DEA);
    }
    if(model.MACD) {
        _lowestValue = MIN(_lowestValue, model.MACD);
        _highestValue = MAX(_highestValue, model.MACD);
    }
}

- (void)drawAxis {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, self.axisShadowWidth);
    CGContextSetStrokeColorWithColor(context, self.axisShadowColor.CGColor);
    CGRect strokeRect = CGRectMake(self.boxOriginX, 0, self.bounds.size.width - self.boxOriginX - self.boxRightMargin, self.bounds.size.height);
    CGContextStrokeRect(context, strokeRect);
}

- (void)drawChart {
    [self showYAxisTitleWithTitles:@[[NSString stringWithFormat:@"%.f", self.highestValue], [NSString stringWithFormat:@"%.f", self.highestValue/2.0], @"万"]];
    [self drawAccessoryView];
}

- (void)drawAccessoryView {
    if (_accessoryChartType != MCStockAccessoryChartTypeMACD) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.kLineWidth);
    
    __block CGFloat xAxis = self.linePadding + self.boxOriginX;
    NSArray *kLineModels = [self.data subarrayWithRange:NSMakeRange(self.startDrawIndex, self.numberOfDrawCount)];
    
    [self resetMaxAndMin];
    
    CGFloat unitValue = [self calcValuePerHeightUnit];
    
    [kLineModels enumerateObjectsUsingBlock:^(MCKLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        UIColor *fillColor = model.MACD > 0 ? self.positiveVolColor : self.negativeVolColor;
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        
        CGRect pathRect = CGRectZero;
        CGFloat centerY = self.frame.size.height + _lowestValue/unitValue - kVerticalMargin;
        
        CGFloat itemHeight = ABS(model.MACD/unitValue);
        if (model.MACD > 0) {
            pathRect = CGRectMake(xAxis, centerY - itemHeight, self.kLineWidth, itemHeight);
        }
        else {
            pathRect = CGRectMake(xAxis, centerY, self.kLineWidth, itemHeight);
        }
        CGContextAddRect(context, pathRect);
        CGContextFillPath(context);
        xAxis += self.kLineWidth + self.linePadding;
    }];
}

- (void)showYAxisTitleWithTitles:(NSArray *)yAxisTitles {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = self.bounds;
    //交易量边框
    CGContextSetLineWidth(context, self.axisShadowWidth);
    CGContextSetStrokeColorWithColor(context, self.axisShadowColor.CGColor);
    CGRect strokeRect = CGRectMake(self.boxOriginX, self.axisShadowWidth/2.0, rect.size.width - self.boxOriginX - self.boxRightMargin, rect.size.height);
    CGContextStrokeRect(context, strokeRect);
    
    [self drawDashLineInContext:context movePoint:CGPointMake(self.boxOriginX + 1.25,
                                                              rect.size.height/2.0)
                        toPoint:CGPointMake(rect.size.width  - self.boxRightMargin - 0.8,
                                            rect.size.height/2.0)];
    
    //这必须把dash给初始化一次，不然会影响其他线条的绘制
    CGContextSetLineDash(context, 0, 0, 0);
    
    for (int i = 0; i < yAxisTitles.count; i ++) {
        NSAttributedString *attString = [MCStockChartUtil attributeText:yAxisTitles[i] textColor:self.yAxisTitleColor font:self.yAxisTitleFont];
        CGSize size = [attString.string stringSizeWithFont:self.yAxisTitleFont];
        
        [attString drawInRect:CGRectMake(rect.size.width - self.boxRightMargin + 2.f,
                                         strokeRect.origin.y + i*strokeRect.size.height/2.0 - size.height/2.0*i - (i==0?2 : 0),
                                         size.width,
                                         size.height)];
    }
}

- (void)drawDashLineInContext:(CGContextRef)context
                    movePoint:(CGPoint)mPoint toPoint:(CGPoint)toPoint {
    CGContextSetLineWidth(context, self.separatorWidth);
    CGFloat lengths[] = {5,5};
    CGContextSetStrokeColorWithColor(context, self.separatorColor.CGColor);
    CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mPoint.x, mPoint.y);    //开始画线
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
    
    CGContextStrokePath(context);
}

@end

