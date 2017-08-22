//
//  Y-KLineGroupModel.h
//  BTC-Kline
//
//  Created by ZK on 16/4/28.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <math.h>
@class MCKLineModel;

@interface MCKLineGroupModel : NSObject

@property (nonatomic, copy) NSArray<MCKLineModel *> *models;

//初始化Model
+ (instancetype)groupModelWithDataSource:(NSArray *)dataSource;

@end

//初始化第一个Model
//第一个 EMA(12) 是前n1个c相加和后除以n1,第一个 EMA(26) 是前n2个c相加和后除以n2
