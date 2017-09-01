//
//  ZKRootViewController.m
//  ZKKLineDemo
//
//  Created by ZK on 2017/8/7.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import "ZKRootViewController.h"
#import "MCStockChartView.h"
#import <YYModel.h>
#import "MacroToolHeader.h"
#import "NetWorking.h"
#import "MCKLineGroupModel.h"

@interface ZKRootViewController () <MCStockChartViewDelegate>

@property (nonatomic, strong) MCStockChartView *kLineChartView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) NSString *typeStr;
@property (nonatomic, strong) NSMutableDictionary <NSString *, MCKLineGroupModel *> *groupModelDict;

@end

@implementation ZKRootViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupNav];
    [self setupKLineView];
    [self requestData];
}

- (void)initData {
    _groupModelDict = [NSMutableDictionary dictionary];
    _typeStr = @"30min";
}

- (void)setupNav {
    self.title = @"币柒网";
    self.view.backgroundColor = GlobalBGColor_Dark;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"旋转" style:UIBarButtonItemStyleDone target:self action:@selector(rotateScreen:)];
    [rightItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rotateScreen:(UIBarButtonItem *)item {
    _kLineChartView.landscapeMode = true;
}

- (void)setupKLineView {
    _kLineChartView = [[MCStockChartView alloc] initWithFrame:CGRectMake(0, 0, self.view.us_width, self.view.us_height)];
    [self.view addSubview:self.kLineChartView];
    _kLineChartView.autoFit = true;
    _kLineChartView.delegate = self;
}

- (void)requestData {
    MCKLineGroupModel *groupModel = _groupModelDict[_typeStr];
    if (groupModel.models) {
        [self.kLineChartView drawChartWithDataSource:groupModel.models];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.typeStr.length ? self.typeStr : @"30min";
    param[@"symbol"] = @"huobibtccny";
    param[@"size"] = @"300";
    
    [NetWorking requestWithApi:@"https://www.btc123.com/kline/klineapi" param:param thenSuccess:^(NSDictionary *responseObject) {
        NSLog(@"接口返回数据：%@", responseObject);
        if ([responseObject[@"isSuc"] boolValue]) {
            MCKLineGroupModel *groupModel = [MCKLineGroupModel groupModelWithDataSource:responseObject[@"datas"]];
            [self.kLineChartView drawChartWithDataSource:groupModel.models];
            self.groupModelDict[_typeStr] = groupModel;
        }
    } fail:^{
        
    }];
}

#pragma mark - <MCStockChartViewDelegate>

- (void)stockChartView:(MCStockChartView *)stockChartView didSelectTargetTime:(MCStockTargetTimeType)targetTimeType {
    if (targetTimeType == MCStockTargetTimeTypeTiming) {
        DLog(@"点击时间轴 == MCStockTargetTimeTypeTiming");
        self.typeStr = @"1min";
    }
    else if (targetTimeType == MCStockTargetTimeTypeMin_5) {
        DLog(@"点击时间轴 == MCStockTargetTimeTypeMin_5");
        self.typeStr = @"5min";
    }
    else if (targetTimeType == MCStockTargetTimeTypeMin_30) {
        DLog(@"点击时间轴 == MCStockTargetTimeTypeMin_30");
        self.typeStr = @"30min";
    }
    else if (targetTimeType == MCStockTargetTimeTypeMin_60) {
        DLog(@"点击时间轴 == MCStockTargetTimeTypeMin_60");
        self.typeStr = @"1hour";
    }
    else if (targetTimeType == MCStockTargetTimeTypeDay) {
        DLog(@"点击时间轴 == MCStockTargetTimeTypeDay");
        self.typeStr = @"1day";
    }
    [self requestData];
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

- (void)dealloc {
    [self stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
