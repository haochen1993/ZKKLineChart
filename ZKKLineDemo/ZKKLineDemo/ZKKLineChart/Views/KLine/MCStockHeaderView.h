//
//  MCStockHeaderView.h
//  ZKKLineDemo
//
//  Created by Zhou Kang on 2017/9/1.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCStockHeaderViewModel : NSObject

@property (nonatomic, assign) CGFloat currentPrice;
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, assign) CGFloat low;
@property (nonatomic, assign) CGFloat high;
@property (nonatomic, assign) CGFloat vol;

@end

// -------

@interface MCStockHeaderView : UIView

+ (instancetype)stockHeaderView;

- (void)updateWithHeaderModel:(MCStockHeaderViewModel *)model;

@end

extern const CGFloat MCStockHeaderViewHeight;
