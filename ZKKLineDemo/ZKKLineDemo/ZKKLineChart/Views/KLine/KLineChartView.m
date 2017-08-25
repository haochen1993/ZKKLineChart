//
//  TYBarChartView.m
//  CandlerstickCharts
//
//  k线图
//  Created by ZhouKang on 16/8/11.
//  Copyright © 2016年 liuxd. All rights reserved.
//

#import "KLineChartView.h"
#import "UIBezierPath+curved.h"
#import "ACMacros.h"
#import "Global+Helper.h"
#import "VolumnView.h"
#import "MCAccessoryView.h"
#import "MCKLineTitleView.h"

#define MaxYAxis       (self.topMargin + self.yAxisHeight)
#define MaxBoundSize   (MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)))
#define MinBoundSize   (MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)))
#define SelfWidth      (_landscapeMode ? MaxBoundSize : MinBoundSize)
#define SelfHeight     (_landscapeMode ? MinBoundSize : MaxBoundSize)

static const NSUInteger kXAxisCutCount = 5; //!< X轴切割份数
static const CGFloat kBarChartHeightRatio = .182f;
static const CGFloat kChartVerticalMargin = 30.f;

@interface KLineChartView ()

@property (nonatomic, assign) CGFloat yAxisHeight;
@property (nonatomic, assign) CGFloat xAxisWidth;
@property (nonatomic, strong) NSArray <MCKLineModel *> *dataSource;
@property (nonatomic, assign) NSInteger startDrawIndex;
@property (nonatomic, assign) NSInteger kLineDrawNum;
@property (nonatomic, strong) MCKLineModel *highestItem;
@property (nonatomic, assign) CGFloat highestPriceOfAll;
@property (nonatomic, assign) CGFloat lowestPriceOfAll;
//手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;
@property (nonatomic, assign) CGFloat lastPanScale;
//坐标轴
@property (nonatomic, strong) NSMutableDictionary *xAxisMapper;
//十字线
@property (nonatomic, strong) UIView *verticalCrossLine;     //垂直十字线
@property (nonatomic, strong) UIView *horizontalCrossLine;   //水平十字线
@property (nonatomic, strong) UIView *barVerticalLine;
// 成交量图
@property (nonatomic, strong) VolumnView *volView;
@property (nonatomic, strong) MCAccessoryView *MACDView;
//时间
@property (nonatomic, strong) UILabel *timeLabel;
//价格
@property (nonatomic, strong) UILabel *priceLabel;
//实时数据提示按钮
@property (nonatomic, strong) UIButton *realDataTipBtn;

@property (nonatomic, assign) CGFloat kLineWidth; //!< k线图宽度
@property (nonatomic, assign) CGFloat kLinePadding; //!< k线图间距
@property (nonatomic, assign) CGFloat maxKLineWidth; //!< k线最大宽度
@property (nonatomic, assign) CGFloat minKLineWidth; //!< k线最小宽度
@property (nonatomic, strong) UIFont *yAxisTitleFont; //!< y坐标轴字体
@property (nonatomic, strong) UIColor *yAxisTitleColor; //!< y坐标轴标题颜色
@property (nonatomic, strong) UIFont *xAxisTitleFont; //!< x坐标轴字体
@property (nonatomic, strong) UIColor *xAxisTitleColor; //!< x坐标轴标题颜色
@property (nonatomic, assign) CGFloat timeAxisHeight; //!< 时间轴高度（默认20.0f）
@property (nonatomic, strong) UIColor *axisShadowColor; //!< 坐标轴边框颜色
@property (nonatomic, assign) CGFloat axisShadowWidth; //!< 坐标轴边框宽度
@property (nonatomic, assign) CGFloat separatorWidth; //!< 分割线宽度
@property (nonatomic, strong) UIColor *separatorColor; //!< 分割线颜色
@property (nonatomic, strong) UIColor *crossLineColor; //!< 十字线颜色
@property (nonatomic, assign) NSInteger saveDecimalPlaces; //!< 保留小数点位数，默认保留两位(最多两位)
@property (nonatomic, strong) UIColor *timeAndPriceTextColor; //!< 时间和价格提示的字体颜色
@property (nonatomic, strong) UIColor *timeAndPriceTipsBackgroundColor; //!< 时间和价格提示背景颜色
@property (nonatomic, assign) CGFloat movingAvgLineWidth; //!< 均线宽度
@property (nonatomic, assign) NSInteger lastDrawNum; //!< 缩放手势 记录上次的绘制个数
@property (nonatomic, strong) MCKLineTitleView *KLineTitleView;

@end

@implementation KLineChartView

#pragma mark - life cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = GlobalColor_Dark;
    
    self.timeAxisHeight = 20.0;
    _landscapeMode = false;
    
    self.positiveLineColor = KLineColor_Green;
    self.negativeLineColor = KLineColor_Red;
    
    self.movingAvgLineWidth = 1.f;
    
    self.MAValues = @[ @7, @12, @26, @30 ];
    self.MAColors = @[ [UIColor lightGrayColor],
                       [UIColor yellowColor],
                       [UIColor purpleColor],
                       [UIColor greenColor], ];
    
    self.axisShadowColor = HexRGB(0x535d69);
    self.axisShadowWidth = 0.5;
    
    self.separatorColor = HexRGB(0x535d69);
    self.separatorWidth = 0.5;
    
    self.yAxisTitleFont = [UIFont systemFontOfSize:8.0];
    self.yAxisTitleColor = [UIColor colorWithRed:(130/255.0f) green:(130/255.0f) blue:(130/255.0f) alpha:1.0];
    
    self.xAxisTitleFont = [UIFont systemFontOfSize:8.0];
    self.xAxisTitleColor = [UIColor colorWithRed:(130/255.0f) green:(130/255.0f) blue:(130/255.0f) alpha:1.0];
    
    self.crossLineColor = HexRGB(0xC9C9C9);
    
    self.zoomEnable = YES;
    
    self.showAvgLine = YES;
    
    self.showBarChart = YES;
    
    self.autoFit = YES;
    
    self.saveDecimalPlaces = 2;
    
    self.timeAndPriceTipsBackgroundColor = HexRGB(0xD70002);
    self.timeAndPriceTextColor = [UIColor colorWithWhite:1.0 alpha:0.95];
    
    self.maxKLineWidth = 24;
    self.minKLineWidth = 1.5;
    
    self.kLineWidth = 4.0;
    self.kLinePadding = 2.0;
    
    self.lastPanScale = 1.0;
    
    self.xAxisMapper = [NSMutableDictionary dictionary];
    
    self.topMargin = 20.0f;
    self.rightMargin = 2.0;
    self.bottomMargin = 250.0f;
    self.leftMargin = 25.0f;
    self.KLineTitleView.hidden = true;
    //添加手势
    [self addGestures];
    [self registerObserver];
}

/**
 *  添加手势
 */
- (void)addGestures {
    [self addGestureRecognizer:self.tapGesture];
    [self addGestureRecognizer:self.panGesture];
    [self addGestureRecognizer:self.pinchGesture];
    [self addGestureRecognizer:self.longGesture];
}

/**
 *  通知
 */
- (void)registerObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self hideTipsWithAnimated:NO];
    [_verticalCrossLine removeFromSuperview];
    _verticalCrossLine = nil;
    [_horizontalCrossLine removeFromSuperview];
    _horizontalCrossLine = nil;
    
    if (!self.dataSource || self.dataSource.count == 0) {
        return;
    }
    //x坐标轴长度
    self.xAxisWidth = rect.size.width - self.rightMargin - self.leftMargin;
    
    //y坐标轴高度
    self.yAxisHeight = rect.size.height - (rect.size.height * kBarChartHeightRatio * 2) - self.topMargin - 30.f;
    
    //坐标轴
    [self drawAxisInRect:rect];
    
    //时间轴
    [self drawTimeAxis];
    
    //k线
    [self drawKLine];
    
    //均线
    [self drawMALine];
    
    //y坐标标题
    [self drawYAxisTitle];
    
    //交易量
    [self drawVol];
}

#pragma mark - render UI

- (void)drawChartWithDataSource:(NSArray<MCKLineModel *> *)dataSource {
    self.dataSource = dataSource;
    
    if (self.showBarChart) {
        self.volView.data = dataSource;
        self.MACDView.data = dataSource;
    }
    
    // 设置
    [self drawSetting];
    
    [self resetMaxAndMin];
    
    [self setNeedsDisplay];
}

- (void)drawSetting {
    NSDictionary *attributes = @{ NSFontAttributeName:self.yAxisTitleFont,
                                  NSForegroundColorAttributeName:self.yAxisTitleColor };
    NSString *priceTitle = [NSString stringWithFormat:@"%.2f", self.highestItem.highestPrice];
    
    NSAttributedString *attString =
    [[NSAttributedString alloc] initWithString:priceTitle
                                    attributes:attributes];
    CGSize size = [attString boundingRectWithSize:CGSizeMake(MAXFLOAT, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.leftMargin = size.width + 4.0f;
    [self resetDrawNumAndIndex];
}

- (void)resetDrawNumAndIndex {
    //更具宽度和间距确定要画多少个k线柱形图
    self.kLineDrawNum = floor(((SelfWidth - self.leftMargin - self.rightMargin - _kLinePadding) / (self.kLineWidth + self.kLinePadding)));
    //确定从第几个开始画
    self.startDrawIndex = self.dataSource.count > 0 ? self.dataSource.count - self.kLineDrawNum : 0;
}

#pragma mark - public methods

- (void)updateChartWithOpen:(CGFloat)open
                      close:(CGFloat)close
                       high:(CGFloat)high
                        low:(CGFloat)low
                       date:(NSString *)date
                      isNew:(BOOL)isNew {
    [self updateChartWithOpen:open close:close high:high low:low date:date mas:nil isNew:isNew];
}

- (void)updateChartWithOpen:(CGFloat)open
                      close:(CGFloat)close
                       high:(CGFloat)high
                        low:(CGFloat)low
                       date:(NSString *)date
                        mas:(NSArray *)mas
                      isNew:(BOOL)isNew {
    MCKLineModel *item= [MCKLineModel new];
    item.openingPrice = open;
    item.closingPrice = close;
    item.highestPrice = high;
    item.lowestPrice = low;
    item.date = date;
    
    if (isNew) {
        self.dataSource = self.dataSource.count != 0 ? [self.dataSource arrayByAddingObject:item] : @[item];
    }
    else {
        if (item.closingPrice == self.dataSource.lastObject.closingPrice) {
            return;
        }
        NSMutableArray *copy = [self.dataSource mutableCopy];
        [copy removeLastObject];
        [copy addObject:item];
        self.dataSource = copy;
    }
    [self drawChartWithDataSource:self.dataSource];
}

#pragma mark - event reponse

- (void)updateChartPressed:(UIButton *)button {
    self.startDrawIndex = self.dataSource.count - self.kLineDrawNum;
}

- (void)tapEvent:(UITapGestureRecognizer *)tapGesture {
    if (self.dataSource.count == 0 || !self.dataSource) {
        return;
    }
    
    CGPoint touchPoint = [tapGesture locationInView:self];
    [self showTipBoardWithTouchPoint:touchPoint];
}

- (void)panEvent:(UIPanGestureRecognizer *)panGesture {
    [self hideTipsWithAnimated:NO];
    CGPoint touchPoint = [panGesture translationInView:self];
    NSInteger offsetIndex = fabs(touchPoint.x / (self.kLineWidth + self.kLinePadding));
    if (self.dataSource.count == 0 || offsetIndex == 0) {
        return;
    }
    if (touchPoint.x > 0) {
        self.startDrawIndex = self.startDrawIndex - offsetIndex < 0 ? 0 : self.startDrawIndex - offsetIndex;
    }
    else {
        self.startDrawIndex = self.startDrawIndex + offsetIndex + self.kLineDrawNum > self.dataSource.count ? self.dataSource.count - self.kLineDrawNum : self.startDrawIndex + offsetIndex;
    }
    [self resetMaxAndMin];
    [panGesture setTranslation:CGPointZero inView:self];
    [self setNeedsDisplay];
}

- (void)pinchEvent:(UIPinchGestureRecognizer *)pinchEvent {
    [self hideTipsWithAnimated:NO];
    CGFloat scale = pinchEvent.scale - self.lastPanScale + 1;
    
    if (!self.zoomEnable || self.dataSource.count == 0) {
        return;
    }
    
    self.kLineWidth = _kLineWidth * scale;
    
    CGFloat forwardDrawCount = self.kLineDrawNum;
    
    _kLineDrawNum = floor((SelfWidth - self.leftMargin - self.rightMargin) / (self.kLineWidth + self.kLinePadding));
    
    //容差处理
    CGFloat diffWidth = (SelfWidth - self.leftMargin - self.rightMargin) - (self.kLineWidth + self.kLinePadding)*_kLineDrawNum;
    if (diffWidth > 4*(self.kLineWidth + self.kLinePadding)/5.0) {
        _kLineDrawNum = _kLineDrawNum + 1;
    }
    
    _kLineDrawNum = (self.dataSource.count > 0 && _kLineDrawNum < self.dataSource.count) ? _kLineDrawNum : self.dataSource.count;
    if (forwardDrawCount == self.kLineDrawNum && self.maxKLineWidth != self.kLineWidth) {
        return;
    }
    
    if ((scale < 1 && _kLineWidth == _minKLineWidth) || (scale > 1 && _kLineWidth == _maxKLineWidth)) {
        return;
    }
    
    NSInteger offset = (NSInteger)((_lastDrawNum - _kLineDrawNum) / 2);
    if (ABS(offset)) {
        _lastDrawNum = _kLineDrawNum;
        if (ABS(offset) < 1.5) {
            _startDrawIndex += offset;
            self.startDrawIndex = self.startDrawIndex + self.kLineDrawNum > self.dataSource.count ? self.dataSource.count - self.kLineDrawNum : self.startDrawIndex;
            [self resetMaxAndMin];
            [self setNeedsDisplay];
        }
    }
    
    pinchEvent.scale = scale;
    self.lastPanScale = pinchEvent.scale;
}

- (void)longPressEvent:(UILongPressGestureRecognizer *)longGesture {
    if (self.dataSource.count == 0 || !self.dataSource) {
        return;
    }
    if (longGesture.state == UIGestureRecognizerStateEnded) {
        [self hideTipsWithAnimated:NO];
    }
    else {
        CGPoint touchPoint = [longGesture locationInView:self];
        [self showTipBoardWithTouchPoint:touchPoint];
    }
}

- (void)showTipBoardWithTouchPoint:(CGPoint)touchPoint {
    CGFloat relativeTouchX = touchPoint.x - _leftMargin;
    // 注意在_xAxisMapper的xAxisKey值是仅仅是坐标原点开始的横坐标值，不是从视图最左开始计算的。即完整的在视图上的坐标需加上_leftMargin
    [self.xAxisMapper enumerateKeysAndObjectsUsingBlock:^(NSNumber *xAxisKey, NSNumber *indexObject, BOOL *stop) {
        CGFloat xAxisValue = [xAxisKey floatValue];
        if (relativeTouchX > xAxisValue - _kLineWidth && relativeTouchX < xAxisValue)  {
            NSInteger index = [indexObject integerValue];
            // 获取对应的k线数据
            MCKLineModel *item = self.dataSource[index];
            CGFloat open = item.openingPrice;
            CGFloat close = item.closingPrice;
            CGFloat scale = (self.highestPriceOfAll - self.lowestPriceOfAll) / self.yAxisHeight;
            scale = scale ?: 1;
            
            CGFloat xAxis = xAxisValue - _kLineWidth / 2.0 + _leftMargin;
            CGFloat yAxis = self.yAxisHeight - (open - self.lowestPriceOfAll)/scale + self.topMargin;
            
            if (item.highestPrice > item.lowestPrice) {
                yAxis = self.yAxisHeight - (close - self.lowestPriceOfAll)/scale + self.topMargin;
            }
            
            [self configUIWithLineItem:item atPoint:CGPointMake(xAxis, yAxis)];
            
            *stop = YES;
        }
    }];
}

- (void)configUIWithLineItem:(MCKLineModel *)item atPoint:(CGPoint)point {
    //十字线
    self.verticalCrossLine.hidden = NO;
    self.verticalCrossLine.us_height = self.showBarChart ? SelfHeight - self.topMargin : self.verticalCrossLine.us_height;
    self.verticalCrossLine.us_left = point.x;
    
    self.horizontalCrossLine.hidden = NO;
    self.horizontalCrossLine.us_top = point.y;
    
    self.barVerticalLine.hidden = NO;
    self.barVerticalLine.us_left = point.x;

    self.KLineTitleView.hidden = false;
    [self.KLineTitleView updateWithHigh:item.highestPrice open:item.openingPrice close:item.closingPrice low:item.lowestPrice];
    
    //时间，价额
    self.priceLabel.hidden = NO;
    self.priceLabel.text = item.openingPrice > item.closingPrice ? [self dealDecimalWithNum:item.openingPrice] : [self dealDecimalWithNum:item.closingPrice] ;
    
    CGFloat priceLabelY = MIN(self.horizontalCrossLine.us_top - (self.timeAxisHeight*2/3.0 - self.separatorWidth*2)/2.0, MaxYAxis - self.timeAxisHeight);
    self.priceLabel.frame = CGRectMake(0.5,
                                       priceLabelY,
                                       self.leftMargin - self.separatorWidth,
                                       self.timeAxisHeight*2/3.0 - self.separatorWidth*2);
    [self bringSubviewToFront:self.priceLabel];
    
    NSString *date = item.date;
    self.timeLabel.text = date;
    self.timeLabel.hidden = !date.length;
    [self bringSubviewToFront:self.timeLabel];
    if (date.length > 0) {
        CGSize size = [date boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.xAxisTitleFont} context:nil].size;
        CGFloat originX = MIN(MAX(0, point.x - size.width/2.0 - 2), SelfWidth - self.rightMargin - size.width - 4);
        self.timeLabel.frame = CGRectMake(originX, MaxYAxis + self.separatorWidth, size.width + 4, self.timeAxisHeight - self.separatorWidth*2);
    }
}

- (void)hideTipsWithAnimated:(BOOL)animated {
    self.horizontalCrossLine.hidden = YES;
    self.verticalCrossLine.hidden = YES;
    self.barVerticalLine.hidden = YES;
    self.priceLabel.hidden = YES;
    self.timeLabel.hidden = YES;
    self.KLineTitleView.hidden = true;
}

#pragma mark - private methods

/**
 *  网格（坐标图）
 */
- (void)drawAxisInRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //k线边框
    CGRect strokeRect = CGRectMake(self.leftMargin, self.topMargin, self.xAxisWidth, self.yAxisHeight);
    CGContextSetLineWidth(context, self.axisShadowWidth);
    CGContextSetStrokeColorWithColor(context, self.axisShadowColor.CGColor);
    CGContextStrokeRect(context, strokeRect);
    
    //k线分割线
    CGFloat avgHeight = strokeRect.size.height/5.0;
    for (int i = 1; i <= 4; i ++) {
        [self drawDashLineInContext:context
                          movePoint:CGPointMake(self.leftMargin + 1.25, self.topMargin + avgHeight*i)
                            toPoint:CGPointMake(rect.size.width  - self.rightMargin - 0.8, self.topMargin + avgHeight*i)];
    }
    
    //这必须把dash给初始化一次，不然会影响其他线条的绘制
    CGContextSetLineDash(context, 0, 0, 0);
}

- (void)drawYAxisTitle {
    //k线y坐标
    CGFloat avgValue = (self.highestPriceOfAll - self.lowestPriceOfAll) / 5.0;
    for (int i = 0; i < 6; i ++) {
        float yAxisValue = i == 5 ? self.lowestPriceOfAll : self.highestPriceOfAll - avgValue*i;
        
        NSAttributedString *attString = [Global_Helper attributeText:[self dealDecimalWithNum:yAxisValue] textColor:self.yAxisTitleColor font:self.yAxisTitleFont];
        CGSize size = [attString boundingRectWithSize:CGSizeMake(self.leftMargin, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        CGFloat diffHeight = 0;
        if (i == 5) {
            diffHeight = size.height;
        }
        else if (i > 0 && i < 5) {
            diffHeight = size.height/2.0;
        }
        [attString drawInRect:CGRectMake(self.leftMargin - size.width - 2.0f, self.yAxisHeight / 5 * i + self.topMargin - diffHeight, size.width, size.height)];
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

- (void)drawTimeAxis {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat widthPerGrid = self.xAxisWidth / kXAxisCutCount;
    NSInteger lineCountPerGrid = ceil(widthPerGrid / (_kLinePadding + _kLineWidth));
    
    CGFloat xAxisValue = self.leftMargin + _kLineWidth/2.0 + _kLinePadding;
    //画X条虚线
    for (int i = 0; i < kXAxisCutCount; i ++) {
        if (xAxisValue > self.leftMargin + self.xAxisWidth) {
            break;
        }
        [self drawDashLineInContext:context movePoint:CGPointMake(xAxisValue, self.topMargin + 1.25) toPoint:CGPointMake(xAxisValue, SelfHeight - 10)];
        //x轴坐标
        NSInteger timeIndex = i * lineCountPerGrid + self.startDrawIndex;
        if (timeIndex > self.dataSource.count - 1) {
            xAxisValue += lineCountPerGrid * (_kLinePadding + _kLineWidth);
            continue;
        }
        NSAttributedString *attString = [Global_Helper attributeText:self.dataSource[timeIndex].date textColor:self.xAxisTitleColor font:self.xAxisTitleFont lineSpacing:2];
        CGSize size = [Global_Helper attributeString:attString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGFloat originX = MAX(MIN(xAxisValue - size.width/2.0, SelfWidth - self.rightMargin - size.width), 0);
        [attString drawInRect:CGRectMake(originX, MaxYAxis + 2.0, size.width, size.height)];
        
        xAxisValue += lineCountPerGrid * (_kLinePadding + _kLineWidth);
    }
    CGContextSetLineDash(context, 0, 0, 0);
}

- (CGFloat)getPricePerHeightUnit {
    return (self.highestPriceOfAll - self.lowestPriceOfAll) / (self.yAxisHeight - kChartVerticalMargin * 2);
}

/**
 *  K线
 */
- (void)drawKLine {
    CGFloat pricePerHeightUnit = [self getPricePerHeightUnit];
    if (pricePerHeightUnit == 0) {
        pricePerHeightUnit = 1.0;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    
    CGFloat xAxis = _kLinePadding;
    [self.xAxisMapper removeAllObjects];
    
    CGPoint maxPoint, minPoint;
    
    NSArray *items = [self.dataSource subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)];
    for (MCKLineModel *item in items) {
        self.xAxisMapper[@(xAxis + _kLineWidth)] = @([self.dataSource indexOfObject:item]);
        //通过开盘价、收盘价判断颜色
        CGFloat open = item.openingPrice;
        CGFloat close = item.closingPrice;
        UIColor *fillColor = open > close ? self.positiveLineColor : self.negativeLineColor;
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        
        CGFloat diffValue = fabs(open - close);
        CGFloat maxValue = MAX(open, close);
        CGFloat KLineHeight = MAX(diffValue/pricePerHeightUnit ?: 1, 0.5);
        CGFloat deltaToBottomAxis = (maxValue - self.lowestPriceOfAll) / pricePerHeightUnit + kChartVerticalMargin;
        CGFloat yAxis = MaxYAxis - (deltaToBottomAxis ?: 1);
        
        CGRect rect = CGRectMake(xAxis + self.leftMargin, yAxis, _kLineWidth, KLineHeight);
        CGContextAddRect(context, rect);
        CGContextFillPath(context);
        
        //上、下影线
        CGFloat highYAxis = MaxYAxis - kChartVerticalMargin - (item.highestPrice - self.lowestPriceOfAll)/pricePerHeightUnit;
        CGFloat lowYAxis = MaxYAxis - kChartVerticalMargin - (item.lowestPrice - self.lowestPriceOfAll)/pricePerHeightUnit;
        CGPoint highPoint = CGPointMake(xAxis + _kLineWidth/2.0 + self.leftMargin, highYAxis);
        CGPoint lowPoint = CGPointMake(xAxis + _kLineWidth/2.0 + self.leftMargin, lowYAxis);
        CGContextSetStrokeColorWithColor(context, fillColor.CGColor);
        CGContextSetLineWidth(context, 1.f);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, highPoint.x, highPoint.y);  //起点坐标
        CGContextAddLineToPoint(context, lowPoint.x, lowPoint.y);   //终点坐标
        CGContextStrokePath(context);
        
        if (item.highestPrice == self.highestPriceOfAll) {
            maxPoint = highPoint;
        }
        if (item.lowestPrice == self.lowestPriceOfAll) {
            minPoint = lowPoint;
        }
        xAxis += _kLineWidth + _kLinePadding;
    }
    
    NSAttributedString *attString = [Global_Helper attributeText:[self dealDecimalWithNum:self.highestPriceOfAll] textColor:HexRGB(0xFFB54C) font:[UIFont systemFontOfSize:12.0f]];
    CGSize textSize = [Global_Helper attributeString:attString boundingRectWithSize:CGSizeMake(100, 100)];
    CGFloat originX = maxPoint.x - textSize.width - self.kLineWidth - 2 < self.leftMargin + self.kLineWidth + 2.0 ? maxPoint.x + self.kLineWidth : maxPoint.x - textSize.width - self.kLineWidth;
    [attString drawInRect:CGRectMake(originX,
                                     maxPoint.y - kChartVerticalMargin,
                                     textSize.width,
                                     textSize.height)];
    
    attString = [Global_Helper attributeText:[self dealDecimalWithNum:self.lowestPriceOfAll] textColor:HexRGB(0xFFB54C) font:[UIFont systemFontOfSize:12.0f]];
    textSize = [Global_Helper attributeString:attString boundingRectWithSize:CGSizeMake(100, 100)];
    originX = minPoint.x - textSize.width - self.kLineWidth - 2 < self.leftMargin + self.kLineWidth + 2.0 ?  minPoint.x + self.kLineWidth : minPoint.x - textSize.width - self.kLineWidth;
    [attString drawInRect:CGRectMake(originX,
                                     self.yAxisHeight - textSize.height + self.topMargin - kChartVerticalMargin,
                                     textSize.width,
                                     textSize.height)];
}

/**
 *  均线图
 */
- (void)drawMALine {
    if (!self.showAvgLine) {
        return;
    }
    NSAssert(self.MAColors.count == self.MAValues.count, @"绘制均线个数与均线绘制颜色个数不一致！");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.movingAvgLineWidth);
    
    for (int i = 0; i < self.MAValues.count; i ++) {
        CGContextSetStrokeColorWithColor(context, self.MAColors[i].CGColor);
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
    
    CGFloat xAxisValue = self.leftMargin + 0.5*_kLineWidth + _kLinePadding;
    CGFloat pricePerHeightUnit = [self getPricePerHeightUnit];
    if (pricePerHeightUnit == 0) {
        pricePerHeightUnit = 1.0f;
    }
    
    // 均线个数
    NSInteger maLength = [self.MAValues[index] integerValue];
    
    // 均线个数达不到三个以上也不绘制
    if (pricePerHeightUnit != 0 || maLength + 2 < self.dataSource.count) {
        NSArray *drawArrays = [self.dataSource subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)];
        for (int i = 0; i < drawArrays.count; i ++) {
            MCKLineModel *item = drawArrays[i];
            
            CGFloat MAValue = 0;
            if (maLength == 7) {
                MAValue = item.MA7;
            }
            else if (maLength == 12) {
                MAValue = item.MA12;
            }
            else if (maLength == 26) {
                MAValue = item.MA26;
            }
            else if (maLength == 30) {
                MAValue = item.MA30;
            }
            // 不足均线个数，则不需要获取该段均线数据(例如: 均5，个数小于5个，则不需要绘制前四均线，...)
            if ([self.dataSource indexOfObject:item] < maLength - 1) {
                xAxisValue += self.kLineWidth + self.kLinePadding;
                continue;
            }
            CGFloat deltaToBottomAxis = (MAValue - self.lowestPriceOfAll) / pricePerHeightUnit + kChartVerticalMargin;
            CGFloat yAxisValue = MaxYAxis - (deltaToBottomAxis ?: 1);
            
            CGPoint maPoint = CGPointMake(xAxisValue, yAxisValue);
            
            if (yAxisValue < self.topMargin || yAxisValue > MaxYAxis) {
                xAxisValue += self.kLineWidth + self.kLinePadding;
                continue;
            }
            if (!path) {
                path = [UIBezierPath bezierPath];
                [path moveToPoint:maPoint];
            }
            else {
                [path addLineToPoint:maPoint];
            }
            xAxisValue += self.kLineWidth + self.kLinePadding;
        }
    }
    //圆滑
    path = [path mc_smoothedPathWithGranularity:15];
    return path.CGPath;
}

/** 绘制交易量柱状图 */
- (void)drawVol {
    if (!self.showBarChart) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.kLineWidth);
    
    CGRect rect = self.bounds;
    
    CGFloat boxOriginY = MaxYAxis + self.timeAxisHeight;
    self.volView.frame = CGRectMake(0, boxOriginY, rect.size.width, rect.size.height * kBarChartHeightRatio);
    self.volView.kLineWidth = self.kLineWidth;
    self.volView.linePadding = self.kLinePadding;
    self.volView.boxOriginX = self.leftMargin;
    self.volView.startDrawIndex = self.startDrawIndex;
    self.volView.numberOfDrawCount = self.kLineDrawNum;
    [self.volView update];
    
    self.MACDView.frame = CGRectMake(0, CGRectGetMaxY(self.volView.frame), rect.size.width, rect.size.height * kBarChartHeightRatio);
    self.MACDView.kLineWidth = self.kLineWidth;
    self.MACDView.linePadding = self.kLinePadding;
    self.MACDView.boxOriginX = self.leftMargin;
    self.MACDView.startDrawIndex = self.startDrawIndex;
    self.MACDView.numberOfDrawCount = self.kLineDrawNum;
    [self.MACDView update];
}

- (void)resetMaxAndMin {
    self.highestPriceOfAll = -MAXFLOAT;
    self.lowestPriceOfAll = MAXFLOAT;
    NSArray *subChartValues = [self.dataSource subarrayWithRange:NSMakeRange(self.startDrawIndex, MIN(self.kLineDrawNum, self.dataSource.count))];
    NSArray *drawContext = self.autoFit ? subChartValues : self.dataSource;
    
    for (int i = 0; i < drawContext.count; i++) {
        MCKLineModel *model = drawContext[i];
        self.highestPriceOfAll = MAX(model.highestPrice, self.highestPriceOfAll);
        self.lowestPriceOfAll = MIN(model.lowestPrice, self.lowestPriceOfAll);
        
        if(model.MA7) {
            if(model.MA7 < _lowestPriceOfAll) {
                _lowestPriceOfAll = model.MA7;
            }
            if(model.MA7 > _highestPriceOfAll) {
                _highestPriceOfAll = model.MA7;
            }
        }
        if(model.MA12) {
            if (_lowestPriceOfAll > model.MA12) {
                _lowestPriceOfAll = model.MA12;
            }
            if (_highestPriceOfAll < model.MA12) {
                _highestPriceOfAll = model.MA12;
            }
        }
        if(model.MA20) {
            if (_lowestPriceOfAll > model.MA20) {
                _lowestPriceOfAll = model.MA20;
            }
            if (_highestPriceOfAll < model.MA20) {
                _highestPriceOfAll = model.MA20;
            }
        }
        if(model.MA26) {
            if (_lowestPriceOfAll > model.MA26) {
                _lowestPriceOfAll = model.MA26;
            }
            if (_highestPriceOfAll < model.MA26) {
                _highestPriceOfAll = model.MA26;
            }
        }
        if(model.MA30) {
            if (_lowestPriceOfAll > model.MA30) {
                _lowestPriceOfAll = model.MA30;
            }
            if (_highestPriceOfAll < model.MA30) {
                _highestPriceOfAll = model.MA30;
            }
        }
    }
}

- (NSString *)dealDecimalWithNum:(CGFloat)num {
    NSString *dealString = nil;
    
    switch (self.saveDecimalPlaces) {
        case 0: {
            dealString = [NSString stringWithFormat:@"%ld", lroundf(num)];
        }
            break;
        case 1: {
            dealString = [NSString stringWithFormat:@"%.1f", num];
        }
            break;
        case 2: {
            dealString = [NSString stringWithFormat:@"%.2f", num];
        }
            break;
        default:
            break;
    }
    
    return dealString;
}

#pragma mark -  public methods

- (void)clear {
    self.dataSource = nil;
    [self setNeedsDisplay];
}

#pragma mark - notificaiton events

- (void)deviceOrientationDidChangeNotification:(NSNotification *)notificaiton {
    
}

#pragma mark - getters

- (VolumnView *)volView {
    if (!_volView) {
        _volView = [VolumnView new];
        _volView.backgroundColor  = [UIColor clearColor];
        _volView.boxRightMargin = self.rightMargin;
        _volView.axisShadowColor = self.axisShadowColor;
        _volView.axisShadowWidth = self.axisShadowWidth;
        _volView.negativeVolColor = self.negativeLineColor;
        _volView.positiveVolColor = self.positiveLineColor;
        _volView.yAxisTitleFont = self.yAxisTitleFont;
        _volView.yAxisTitleColor = self.yAxisTitleColor;
        _volView.separatorWidth = self.separatorWidth;
        _volView.separatorColor = self.separatorColor;
        [self addSubview:_volView];
    }
    return _volView;
}

- (MCAccessoryView *)MACDView {
    if (!_MACDView) {
        _MACDView = [MCAccessoryView new];
        _MACDView.backgroundColor  = [UIColor clearColor];
        _MACDView.boxRightMargin = self.rightMargin;
        _MACDView.axisShadowColor = self.axisShadowColor;
        _MACDView.axisShadowWidth = self.axisShadowWidth;
        _MACDView.negativeVolColor = self.negativeLineColor;
        _MACDView.positiveVolColor = self.positiveLineColor;
        _MACDView.yAxisTitleFont = self.yAxisTitleFont;
        _MACDView.yAxisTitleColor = self.yAxisTitleColor;
        _MACDView.separatorWidth = self.separatorWidth;
        _MACDView.separatorColor = self.separatorColor;
        [self addSubview:_MACDView];
    }
    return _MACDView;
}

- (UIView *)verticalCrossLine {
    if (!_verticalCrossLine) {
        _verticalCrossLine = [[UIView alloc] initWithFrame:CGRectMake(self.leftMargin, self.topMargin, 0.5, self.yAxisHeight)];
        _verticalCrossLine.backgroundColor = self.crossLineColor;
        [self addSubview:_verticalCrossLine];
    }
    return _verticalCrossLine;
}

- (UIView *)horizontalCrossLine {
    if (!_horizontalCrossLine) {
        _horizontalCrossLine = [[UIView alloc] initWithFrame:CGRectMake(self.leftMargin, self.topMargin, self.xAxisWidth, 0.5)];
        _horizontalCrossLine.backgroundColor = self.crossLineColor;
        [self addSubview:_horizontalCrossLine];
    }
    return _horizontalCrossLine;
}

- (UIView *)barVerticalLine {
    if (!_barVerticalLine) {
        _barVerticalLine = [[UIView alloc] initWithFrame:CGRectMake(self.leftMargin, MaxYAxis + self.timeAxisHeight, 0.5, SelfHeight - (MaxYAxis + self.timeAxisHeight))];
        _barVerticalLine.backgroundColor = self.crossLineColor;
        [self addSubview:_barVerticalLine];
    }
    return _barVerticalLine;
}

- (UIButton *)realDataTipBtn {
    if (!_realDataTipBtn) {
        _realDataTipBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_realDataTipBtn setTitle:@"New Data" forState:UIControlStateNormal];
        [_realDataTipBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _realDataTipBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _realDataTipBtn.frame = CGRectMake(SelfWidth - self.rightMargin - 60.0f, self.topMargin + 10.0f, 60.0f, 25.0f);
        [_realDataTipBtn addTarget:self action:@selector(updateChartPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_realDataTipBtn];
        _realDataTipBtn.layer.borderWidth = 1.0;
        _realDataTipBtn.layer.borderColor = [UIColor redColor].CGColor;
        _realDataTipBtn.hidden = YES;
    }
    return _realDataTipBtn;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor = self.timeAndPriceTipsBackgroundColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = self.yAxisTitleFont;
        _timeLabel.textColor = self.timeAndPriceTextColor;
        _timeLabel.numberOfLines = 0;
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.backgroundColor = self.timeAndPriceTipsBackgroundColor;
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = [UIFont systemFontOfSize:self.xAxisTitleFont.pointSize + 2.0];
        _priceLabel.textColor = self.timeAndPriceTextColor;
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (MCKLineTitleView *)KLineTitleView {
    if (!_KLineTitleView) {
        _KLineTitleView = [MCKLineTitleView titleView];
        [self addSubview:_KLineTitleView];
    }
    _KLineTitleView.frame = CGRectMake(_leftMargin + 10, _topMargin, SelfWidth, 20);
    return _KLineTitleView;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    }
    return _tapGesture;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
    }
    return _panGesture;
}

- (UIPinchGestureRecognizer *)pinchGesture {
    if (!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchEvent:)];
    }
    return _pinchGesture;
}

- (UILongPressGestureRecognizer *)longGesture {
    if (!_longGesture) {
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    }
    return _longGesture;
}

#pragma mark - setters 

- (void)setDataSource:(NSArray<MCKLineModel *> *)chartValues {
    _dataSource = chartValues;
    
    CGFloat maxHigh = -MAXFLOAT;
    for (MCKLineModel *item in self.dataSource) {
        if (item.highestPrice > maxHigh) {
            maxHigh = item.highestPrice;
            self.highestItem = item;
        }
    }
}

- (void)setKLineDrawNum:(NSInteger)kLineDrawNum {
    _kLineDrawNum = MAX(MIN(self.dataSource.count, kLineDrawNum), 0);
    
    if (_kLineDrawNum != 0) {
        self.kLineWidth = (SelfWidth - self.leftMargin - self.rightMargin - _kLinePadding)/_kLineDrawNum - _kLinePadding;
    }
}

- (void)setKLineWidth:(CGFloat)kLineWidth {
    _kLineWidth = MIN(MAX(kLineWidth, self.minKLineWidth), self.maxKLineWidth);
}

- (void)setMaxKLineWidth:(CGFloat)maxKLineWidth {
    if (maxKLineWidth < _minKLineWidth) {
        maxKLineWidth = _minKLineWidth;
    }
    
    CGFloat realAxisWidth = (SelfWidth - self.leftMargin - self.rightMargin - _kLinePadding);
    NSInteger maxKLineCount = floor(realAxisWidth)/(maxKLineWidth + _kLinePadding);
    maxKLineWidth = realAxisWidth/maxKLineCount - _kLinePadding;
    
    _maxKLineWidth = maxKLineWidth;
}

- (void)setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
    self.maxKLineWidth = _maxKLineWidth;
}

- (void)setLandscapeMode:(BOOL)landscapeMode {
    _landscapeMode = landscapeMode;
    CGFloat angle = 0;
    CGRect bounds = CGRectZero;
    CGPoint center = CGPointZero;
    
    if (landscapeMode) {
        angle = M_PI_2;
        bounds = CGRectMake(0, 0, CGRectGetHeight(self.superview.bounds) - 64.f, CGRectGetWidth(self.superview.bounds));
        center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds) + 32.f);
    }
    else {
        angle = 0;
        bounds = CGRectMake(0, 0, CGRectGetWidth(self.superview.bounds), CGRectGetHeight(self.superview.bounds) - 64.f);
        center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds) + 32.f);
    }
    [UIView animateWithDuration:.33 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeRotation(angle);
        self.bounds = bounds;
        self.center = center;
    } completion:nil];
    [self drawChartWithDataSource:_dataSource];
}

- (void)setBottomMargin:(CGFloat)bottomMargin {
    _bottomMargin = bottomMargin < _timeAxisHeight ? _timeAxisHeight : bottomMargin;
}

- (void)dealloc {
    [self removeObserver];
}

@end
