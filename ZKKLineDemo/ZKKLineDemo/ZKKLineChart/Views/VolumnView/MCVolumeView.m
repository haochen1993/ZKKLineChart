//
//  VolumnView.m
//  ChartDemo
//
//  Created by ZhouKang on 2016/11/17.
//  Copyright © 2016年 ZhouKang. All rights reserved.
//

#import "MCVolumeView.h"
#import "KLineListTransformer.h"
#import "MCKLineModel.h"
#import "UIBezierPath+curved.h"
#import "MCKLineTitleView.h"
#import "MCStockChartUtil.h"

@interface MCVolumeView ()

@property (nonatomic) float maxValue;

@property (nonatomic) float minValue;

@property (nonatomic, copy) NSArray *MAValues;

@end

static const CGFloat kVerticalMargin = 12.f;

@implementation MCVolumeView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.volStyle = CandlerstickChartsVolStyleDefault;
    
    _MAValues = @[ @7, @30 ];
    
    _maxValue = -MAXFLOAT;
    _minValue = MAXFLOAT;
}

// overrite
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self drawAxis];
    [self drawChart];
    [self drawMALine];
}

- (void)showTitleView:(MCKLineModel *)model {
    [super showTitleView:model];
    [self.titleView updateWithVolume:model.volume MA5:model.MA7 MA10:model.MA20];
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

/**
 *  均线path
 */
- (CGPathRef)movingAvgGraphPathForContextAtIndex:(NSInteger)index {
    UIBezierPath *path = nil;
    CGFloat xAxisValue = self.boxOriginX + 0.5*self.kLineWidth + self.linePadding;
    CGFloat volumePerHeightUnit = [self getVolumePerHeightUnit];
    if (volumePerHeightUnit == 0) {
        volumePerHeightUnit = 1.0f;
    }
    // 均线个数
    NSInteger maLength = [self.MAValues[index] integerValue];
    
    NSArray *drawArrays = [self.data subarrayWithRange:NSMakeRange(self.startDrawIndex, self.numberOfDrawCount)];
    for (int i = 0; i < drawArrays.count; i ++) {
        MCKLineModel *item = drawArrays[i];
        
        CGFloat MAValue = 0;
        if (maLength == 7) {
            MAValue = item.Volume_MA7;
        }
        else if (maLength == 30) {
            MAValue = item.Volume_MA30;
        }
        // 不足均线个数，则不需要获取该段均线数据(例如: 均5，个数小于5个，则不需要绘制前四均线，...)
        if ([self.data indexOfObject:item] < maLength - 1) {
            xAxisValue += self.kLineWidth + self.linePadding;
            continue;
        }
        CGFloat deltaToBottomAxis = MAValue / volumePerHeightUnit;
        CGFloat yAxisValue = self.bounds.size.height - (deltaToBottomAxis ?: 1);
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
    [self reset];
    [self setNeedsDisplay];
}

#pragma mark - private methods

- (void)reset {
    _maxValue = -MAXFLOAT;
    _minValue = MAXFLOAT;
    switch (self.volStyle) {
        case CandlerstickChartsVolStyleDefault: {
            NSArray *volums = [self.data subarrayWithRange:NSMakeRange(self.startDrawIndex, self.numberOfDrawCount)];
            for (MCKLineModel *item in volums) {
                if (self.maxValue < item.volume) {
                    self.maxValue = item.volume;
                }
                
                if (self.minValue > item.volume) {
                    self.minValue = item.volume;
                }
            }
            break;
        }
        default:
            break;
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
    switch (self.volStyle) {
        case CandlerstickChartsVolStyleDefault: {
            [self showYAxisTitleWithTitles:@[[NSString stringWithFormat:@"%.f", self.maxValue], [NSString stringWithFormat:@"%.f", self.maxValue/2.0], @"万"]];
            [self drawVolView];
            break;
        }
        case CandlerstickChartsVolStyleRSV9: {
            break;
        }
            
        case CandlerstickChartsVolStyleKDJ: {
            break;
        }
            
        case CandlerstickChartsVolStyleMACD: {
            break;
        }
            
        case CandlerstickChartsVolStyleRSI: {
            break;
        }
            
        case CandlerstickChartsVolStyleBOLL: {
            break;
        }
            
        case CandlerstickChartsVolStyleDMA: {
            break;
        }
            
        case CandlerstickChartsVolStyleCCI: {
            break;
        }
            
        case CandlerstickChartsVolStyleWR: {
            break;
        }
        case CandlerstickChartsVolStyleBIAS: {
            break;
        }
        default:
            break;
    }
}

/**
 *  交易量
 */
- (void)drawVolView {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.kLineWidth);
    
    CGRect rect = self.bounds;
    
    CGFloat xAxis = self.linePadding + self.boxOriginX;
    
    CGFloat boxOriginY = self.axisShadowWidth;
    CGFloat boxHeight = rect.size.height - boxOriginY;
    CGFloat volumePerUnit = [self getVolumePerHeightUnit];
    
    NSArray *contentValues = [self.data subarrayWithRange:NSMakeRange(self.startDrawIndex, self.numberOfDrawCount)];
    for (MCKLineModel *item in contentValues) {
        CGFloat open = item.openingPrice;
        CGFloat close = item.closingPrice;
        UIColor *fillColor = open > close ? self.positiveVolColor : self.negativeVolColor;
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        
        CGFloat height = item.volume/volumePerUnit ?: 1.f;
        CGRect pathRect = CGRectMake(xAxis, boxOriginY + boxHeight - height, self.kLineWidth, height - self.axisShadowWidth);
        CGContextAddRect(context, pathRect);
        CGContextFillPath(context);
        
        xAxis += self.kLineWidth + self.linePadding;
    }
}

- (CGFloat)getVolumePerHeightUnit {
    return self.maxValue/(self.frame.size.height - self.axisShadowWidth - kVerticalMargin);
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

#pragma mark - events

- (void)switchEvent:(UITapGestureRecognizer *)tapGesture {
    return;
    switch (self.volStyle) {
        case CandlerstickChartsVolStyleDefault: {
            self.volStyle = CandlerstickChartsVolStyleRSV9;
            break;
        }
        case CandlerstickChartsVolStyleRSV9: {
            self.volStyle = CandlerstickChartsVolStyleKDJ;
            break;
        }
            
        case CandlerstickChartsVolStyleKDJ: {
            self.volStyle = CandlerstickChartsVolStyleMACD;
            break;
        }
            
        case CandlerstickChartsVolStyleMACD: {
            self.volStyle = CandlerstickChartsVolStyleRSI;
            break;
        }
            
        case CandlerstickChartsVolStyleRSI: {
            self.volStyle = CandlerstickChartsVolStyleBOLL;
            break;
        }
            
        case CandlerstickChartsVolStyleBOLL: {
            self.volStyle = CandlerstickChartsVolStyleDMA;
            break;
        }
            
        case CandlerstickChartsVolStyleDMA: {
            self.volStyle = CandlerstickChartsVolStyleCCI;
            break;
        }
            
        case CandlerstickChartsVolStyleCCI: {
            self.volStyle = CandlerstickChartsVolStyleWR;
            break;
        }
            
        case CandlerstickChartsVolStyleWR: {
            self.volStyle = CandlerstickChartsVolStyleBIAS;
            break;
        }
        case CandlerstickChartsVolStyleBIAS: {
            self.volStyle = CandlerstickChartsVolStyleDefault;
            break;
        }
        default:
            break;
    }
    
    [self update];
    [self setNeedsDisplay];
}

@end
