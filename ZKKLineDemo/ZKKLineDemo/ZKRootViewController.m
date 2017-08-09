//
//  ZKRootViewController.m
//  ZKKLineDemo
//
//  Created by ZK on 2017/8/7.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import "ZKRootViewController.h"
#import "KLineChartView.h"
#import "KLineListTransformer.h"
#import "StatusView.h"
#import <YYModel.h>
#import "ZKKLineItem.h"
#import "ACMacros.h"

@interface ZKRootViewController ()

@property (nonatomic, strong) KLineListTransformer *lineListTransformer;
@property (nonatomic, strong) KLineChartView *kLineChartView;

@property (nonatomic, strong) StatusView *kStatusView;

/**
 *  (模拟)实时测试
 */
@property (nonatomic, strong) NSArray <ZKKLineItem *> *dataSource;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZKRootViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"币柒网";
    [self setupKLineView];
    [self requestData];
}

- (void)setupKLineView {
    _kLineChartView = [[KLineChartView alloc] initWithFrame:CGRectMake(0, 64, self.view.us_width, self.view.us_height - 64)];
    [self.view addSubview:self.kLineChartView];
    
    _kLineChartView.backgroundColor = HexRGB(0x292c34);
    _kLineChartView.topMargin = 20.0f;
    _kLineChartView.rightMargin = 1.0;
    _kLineChartView.bottomMargin = 250.0f;
    _kLineChartView.leftMargin = 25.0f;
    _kLineChartView.yAxisTitleIsChange = true;
    
    // 绘制均线
    
    self.kLineChartView.Mas = @[ @5, @10, @30, @60 ];
    
    self.kLineChartView.masColors = @[
                                      [UIColor grayColor],
                                      [UIColor yellowColor],
                                      [UIColor purpleColor],
                                      [UIColor greenColor],
                                      ];
}

- (void)requestData {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"source.json" ofType:nil];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:nil];
    NSArray *sourceArray = dict[@"data"];
    
    self.dataSource = [NSArray yy_modelArrayWithClass:[ZKKLineItem class] json:sourceArray];
    [self.kLineChartView drawChartWithDataSource:self.dataSource];
}

#pragma mark - private methods

- (void)startTimer {
    [self stopTimer];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(realTimeData:) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (_timer && [_timer isValid]) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
    _timer = nil;
}

- (void)realTimeData:(id)timer {
}

#pragma mark - getters

- (StatusView *)kStatusView {
    if (!_kStatusView) {
        _kStatusView = [[StatusView alloc] initWithFrame:_kLineChartView.bounds];
    }
    return _kStatusView;
}

- (KLineListTransformer *)lineListTransformer {
    if (!_lineListTransformer) {
        _lineListTransformer = [KLineListTransformer new];
    }
    return _lineListTransformer;
}

- (void)dealloc {
    [self stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
