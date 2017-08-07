//
//  ZKKLineItem.h
//  ChartDemo
//
//  Created by ZhouKang on 2016/12/2.
//  Copyright © 2016年 ZhouKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYModel.h>

@interface ZKKLineItem : NSObject <YYModel>

@property (nonatomic, assign) CGFloat openingPrice; //!< 开盘价

@property (nonatomic, assign) CGFloat closingPrice; //!< 收盘价

@property (nonatomic, assign) CGFloat highestPrice; //!< 最高价

@property (nonatomic, assign) CGFloat lowestPrice; //!< 最低价

@property (nonatomic, copy) NSString *date; //!< 日期

@property (nonatomic, assign) CGFloat vol; //!< 成交量

@end
