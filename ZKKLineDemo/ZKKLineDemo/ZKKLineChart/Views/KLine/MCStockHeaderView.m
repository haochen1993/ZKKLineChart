//
//  MCStockHeaderView.m
//  ZKKLineDemo
//
//  Created by Zhou Kang on 2017/9/1.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import "MCStockHeaderView.h"

const CGFloat MCStockHeaderViewHeight = 60.f;

@interface MCStockHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *volLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;

@end

@implementation MCStockHeaderView

+ (instancetype)stockHeaderView {
    MCStockHeaderView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    return view;
}

@end


