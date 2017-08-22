//
//  Y_KLinePositionModel.m
//  BTC-Kline
//
//  Created by ZK on 16/5/2.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "MCKLinePositionModel.h"

@implementation MCKLinePositionModel

+ (instancetype) modelWithOpen:(CGPoint)openPoint
                         close:(CGPoint)closePoint
                          high:(CGPoint)highPoint
                           low:(CGPoint)lowPoint {
    MCKLinePositionModel *model = [MCKLinePositionModel new];
    model.OpenPoint = openPoint;
    model.ClosePoint = closePoint;
    model.HighPoint = highPoint;
    model.LowPoint = lowPoint;
    return model;
}

@end
