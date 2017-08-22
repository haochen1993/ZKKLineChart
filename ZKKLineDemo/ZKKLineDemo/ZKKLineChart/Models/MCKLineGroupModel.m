//
//  Y-KLineGroupModel.m
//  BTC-Kline
//
//  Created by ZK on 16/4/28.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "MCKLineGroupModel.h"
#import "MCKLineModel.h"

@implementation MCKLineGroupModel

+ (instancetype)groupModelWithDataSource:(NSArray *)dataSource {
    NSAssert([dataSource isKindOfClass:[NSArray class]], @"arr不是一个数组");
    
    MCKLineGroupModel *groupModel = [MCKLineGroupModel new];
    NSMutableArray *mutableArr = @[].mutableCopy;
    MCKLineModel *preModel = [[MCKLineModel alloc] init];
    
    //设置数据
    for (NSArray *valueArr in dataSource) {
        MCKLineModel *model = [MCKLineModel new];
        model.PreviousKlineModel = preModel;
        [model initWithValues:valueArr];
        model.ParentGroupModel = groupModel;
        
        [mutableArr addObject:model];
        
        preModel = model;
    }
    
    groupModel.models = mutableArr;
    
    //初始化第一个Model的数据
    MCKLineModel *firstModel = mutableArr[0];
    [firstModel initFirstModel];
    
    //初始化其他Model的数据
    [mutableArr enumerateObjectsUsingBlock:^(MCKLineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [model initData];
    }];

    return groupModel;
}

@end
