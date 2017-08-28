//
//  VolumnView.m
//  ChartDemo
//
//  Created by ZhouKang on 2016/11/17.
//  Copyright © 2016年 ZhouKang. All rights reserved.
//

#import "MCAccessoryView.h"
#import "KLineListTransformer.h"
#import "MCKLineModel.h"
#import "UIBezierPath+curved.h"
#import "MCStockChartUtil.h"

@interface MCAccessoryView ()

@property (nonatomic) CGFloat highestValue;

@property (nonatomic) CGFloat lowestValue;

@property (nonatomic, copy) NSArray *MAValues;

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
    _MAValues = @[ @7, @30 ];
    
    _highestValue = -MAXFLOAT;
    _lowestValue = MAXFLOAT;
}

// overrite
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self drawAxis];
    [self drawChart];
    [self drawMALine];
}

/**
 *  均线图
 */
- (void)drawMALine {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.f);
    UIColor *colors[] = { [UIColor whiteColor], [UIColor yellowColor] };
    for (int i = 0; i < _MAValues.count; i ++) {
        CGContextSetStrokeColorWithColor(context, colors[i].CGColor);
        CGPathRef path = [self movingAvgGraphPathForContextAtIndex:i];
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
}

- (CGFloat)calcValuePerHeightUnit {
    CGFloat unitValue = (_highestValue - _lowestValue) / (self.frame.size.height - kVerticalMargin * 2);
    return unitValue;
}

/**
 *  均线path
 */
- (CGPathRef)movingAvgGraphPathForContextAtIndex:(NSInteger)index {
    UIBezierPath *path = nil;
    CGFloat xAxisValue = self.boxOriginX + 0.5*self.kLineWidth + self.linePadding;
    CGFloat unitValue = [self calcValuePerHeightUnit];
    if (unitValue == 0) {
        unitValue = 1.0f;
    }
    // 均线个数
    NSInteger maLength = [self.MAValues[index] integerValue];
    
    NSArray *drawArrays = [self.data subarrayWithRange:NSMakeRange(self.startDrawIndex, self.numberOfDrawCount)];
    for (int i = 0; i < drawArrays.count; i ++) {
        MCKLineModel *item = drawArrays[i];
        
        CGFloat MAValue = 0;
        if (maLength == 7) {
            MAValue = item.DEA;
        }
        else if (maLength == 30) {
            MAValue = item.DIF;
        }
        // 不足均线个数，则不需要获取该段均线数据(例如: 均5，个数小于5个，则不需要绘制前四均线，...)
        if ([self.data indexOfObject:item] < maLength - 1) {
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
    
    NSArray *volums = [self.data subarrayWithRange:NSMakeRange(self.startDrawIndex, self.numberOfDrawCount)];
    for (MCKLineModel *model in volums) {
        if(model.DIF) {
            if(model.DIF < _lowestValue) {
                _lowestValue = model.DIF;
            }
            if(model.DIF > _highestValue) {
                _highestValue = model.DIF;
            }
        }
        if(model.DEA) {
            if (_lowestValue > model.DEA) {
                _lowestValue = model.DEA;
            }
            if (_highestValue < model.DEA) {
                _highestValue = model.DEA;
            }
        }
        if(model.MACD) {
            if (_lowestValue > model.MACD) {
                _lowestValue = model.MACD;
            }
            if (_highestValue < model.MACD) {
                _highestValue = model.MACD;
            }
        }
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
    [self drawVolView];
}

/**
 *  交易量
 */
- (void)drawVolView {
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

- (void)showYAxisTitleWithTitles:(NSArray *)yAxis {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = self.bounds;
    //交易量边框
    CGContextSetLineWidth(context, self.axisShadowWidth);
    CGContextSetStrokeColorWithColor(context, self.axisShadowColor.CGColor);
    CGRect strokeRect = CGRectMake(self.boxOriginX, self.axisShadowWidth/2.0, rect.size.width - self.boxOriginX - self.boxRightMargin, rect.size.height);
    CGContextStrokeRect(context, strokeRect);
    
    [self drawDashLineInContext:context movePoint:CGPointMake(self.boxOriginX + 1.25, rect.size.height/2.0)
                        toPoint:CGPointMake(rect.size.width  - self.boxRightMargin - 0.8, rect.size.height/2.0)];
    
    //这必须把dash给初始化一次，不然会影响其他线条的绘制
    CGContextSetLineDash(context, 0, 0, 0);
    
    for (int i = 0; i < yAxis.count; i ++) {
        NSAttributedString *attString = [MCStockChartUtil attributeText:yAxis[i] textColor:self.yAxisTitleColor font:self.yAxisTitleFont];
        CGSize size = [MCStockChartUtil attributeString:attString boundingRectWithSize:CGSizeMake(self.boxOriginX, self.yAxisTitleFont.lineHeight)];
        
        [attString drawInRect:CGRectMake(self.boxOriginX - size.width - 2.0f, strokeRect.origin.y + i*strokeRect.size.height/2.0 - size.height/2.0*i - (i==0?2 : 0), size.width, size.height)];
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

