//
//  KLineListManager.h
//  ChartDemo
//
//  Created by ZhouKang on 16/8/12.
//  Copyright © 2016年 ZhouKang. All rights reserved.
//

#import "GApiBaseManager.h"

@interface KLineListManager : GApiBaseManager <GAPIManager, GAPIManagerDataSource>

@property (nonatomic, copy) NSString *kLineID;

/**
 *  日期［w, s, d］
 */
@property (nonatomic, copy) NSString *dateType;

@end
