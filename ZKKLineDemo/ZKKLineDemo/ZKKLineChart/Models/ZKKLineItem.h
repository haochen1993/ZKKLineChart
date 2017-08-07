//
//  ZKKLineItem.h
//  ChartDemo
//
//  Created by ZhouKang on 2016/12/2.
//  Copyright © 2016年 ZhouKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface ZKKLineItem : NSObject <YYModel>

@property (nonatomic, copy) NSNumber *openingPrice; //!< 开盘价

@property (nonatomic, copy) NSNumber *closingPrice; //!< 收盘价

@property (nonatomic, copy) NSNumber *highestPrice; //!< 最高价

@property (nonatomic, copy) NSNumber *lowestPrice; //!< 最低价

@property (nonatomic, copy) NSString *date; //!< 日期

@property (nonatomic, copy) NSNumber *vol; //!< 成交量

@end
