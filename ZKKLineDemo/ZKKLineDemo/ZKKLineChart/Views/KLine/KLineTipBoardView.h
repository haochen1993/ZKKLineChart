//
//  KLineTipBoardView.h
//  ChartDemo
//
//  Created by ZhouKang on 16/8/23.
//  Copyright © 2016年 ZhouKang. All rights reserved.
//

#import "TipBoardView.h"

@interface KLineTipBoardView : TipBoardView

@property (nonatomic, copy) NSString *openingPrice; //!< 开盘价

@property (nonatomic, copy) NSString *closingPrice; //!< 收盘价

@property (nonatomic, copy) NSString *highestPrice; //!< 最高价

@property (nonatomic, copy) NSString *lowestPrice; //!< 最低价

/**************************************************/
/*                     字体颜色                    */
/**************************************************/
//提供不一样的字体颜色可供选择， 默认都｛白色｝

@property (nonatomic, strong) UIColor *openColor; //!< 开盘价颜色

@property (nonatomic, strong) UIColor *closeColor; //!< 收盘价颜色

@property (nonatomic, strong) UIColor *highColor; //!< 最高价颜色

@property (nonatomic, strong) UIColor *lowColor; //!< 最低价颜色

@end
