//
//  Y_KLinePositionModel.h
//  BTC-Kline
//
//  Created by ZK on 16/5/2.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCKLinePositionModel : NSObject

/**
 *  开盘点
 */
@property (nonatomic, assign) CGPoint OpenPoint;

/**
 *  收盘点
 */
@property (nonatomic, assign) CGPoint ClosePoint;

/**
 *  最高点
 */
@property (nonatomic, assign) CGPoint HighPoint;

/**
 *  最低点
 */
@property (nonatomic, assign) CGPoint LowPoint;

/**
 *  工厂方法
 */
+ (instancetype) modelWithOpen:(CGPoint)openPoint
                         close:(CGPoint)closePoint
                          high:(CGPoint)highPoint
                           low:(CGPoint)lowPoint;

@end
