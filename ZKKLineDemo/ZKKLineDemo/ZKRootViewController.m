//
//  ZKRootViewController.m
//  ZKKLineDemo
//
//  Created by ZK on 2017/8/7.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import "ZKRootViewController.h"
#import "KLineChartView.h"
#import "TLineChartView.h"
#import "KLineListTransformer.h"
#import "StatusView.h"
#import <YYModel.h>
#import "ZKKLineItem.h"

@interface ZKRootViewController ()

@property (nonatomic, strong) KLineListTransformer *lineListTransformer;
@property (nonatomic, strong) KLineChartView *kLineChartView;
@property (nonatomic, strong) TLineChartView *tLineChartView;

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
    
    [self.view addSubview:self.kLineChartView];
    [self.view addSubview:self.tLineChartView];
    
    // 绘制均线
    
    self.kLineChartView.Mas = @[ @5, @10, @30, @60 ];
    
    self.kLineChartView.masColors = @[
                                      [UIColor grayColor],
                                      [UIColor yellowColor],
                                      [UIColor purpleColor],
                                      [UIColor greenColor],
                                      ];
    
    [self requestData];
    /*[self.kLineChartView addSubview:self.kStatusView];
     
     __block typeof(self) weakSelf = self;
     self.kStatusView.reloadBlock = ^(){
     [weakSelf.chartApi startRequest];
     };
     
     //发起请求
     self.chartApi.dateType = @"d";
     self.chartApi.kLineID = @"601888.SS";
     [self.chartApi startRequest];*/
}

- (void)requestData {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"data.plist" ofType:nil];
    NSArray *sourceArray = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"data"];
    self.dataSource = [NSArray yy_modelArrayWithClass:[ZKKLineItem class] json:sourceArray];
    [self.kLineChartView drawChartWithDataSource:self.dataSource];
    [self.tLineChartView drawChartWithData:self.dataSource];
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

- (KLineChartView *)kLineChartView {
    if (!_kLineChartView) {
        _kLineChartView = [[KLineChartView alloc] initWithFrame:CGRectMake(20, 50, self.view.frame.size.width - 40.0f, 300.0f)];
        _kLineChartView.backgroundColor = [UIColor whiteColor];
        _kLineChartView.topMargin = 20.0f;
        _kLineChartView.rightMargin = 1.0;
        _kLineChartView.bottomMargin = 80.0f;
        _kLineChartView.leftMargin = 25.0f;
        _kLineChartView.yAxisTitleIsChange = false;
        // YES表示：Y坐标的值根据视图中呈现的k线图的最大值最小值变化而变化；NO表示：Y坐标是所有数据中的最大值最小值，不管k线图呈现如何都不会变化。默认YES
        //_kLineChartView.yAxisTitleIsChange = NO;
        
        // 及时更新k线图
        //_kLineChartView.dynamicUpdateIsNew = YES;
        
        //是否支持手势
        //_kLineChartView.supportGesture = NO;
    }
    return _kLineChartView;
}

- (TLineChartView *)tLineChartView {
    if (!_tLineChartView) {
        _tLineChartView = [[TLineChartView alloc] initWithFrame:CGRectMake(20, 380.0f, self.view.frame.size.width - 40.0f, 180.0f)];
        _tLineChartView.backgroundColor = [UIColor whiteColor];
        _tLineChartView.topMargin = 5.0f;
        _tLineChartView.leftMargin = 50.0;
        _tLineChartView.bottomMargin = 0.5;
        _tLineChartView.rightMargin = 1.0;
        _tLineChartView.pointPadding = 30.0f;
        _tLineChartView.separatorNum = 4;
        _tLineChartView.flashPoint = YES;
        //_tLineChartView.smoothPath = NO;
    }
    return _tLineChartView;
}

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
