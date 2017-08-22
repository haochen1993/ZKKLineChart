//
//  MCKLineVolumePositionModel.m
//  BTC-Kline
//
//  Created by ZK on 16/5/3.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "MCKLineVolumePositionModel.h"

@implementation MCKLineVolumePositionModel

+ (instancetype) modelWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    MCKLineVolumePositionModel *volumePositionModel = [MCKLineVolumePositionModel new];
    volumePositionModel.StartPoint = startPoint;
    volumePositionModel.EndPoint = endPoint;
    return volumePositionModel;
}

@end
