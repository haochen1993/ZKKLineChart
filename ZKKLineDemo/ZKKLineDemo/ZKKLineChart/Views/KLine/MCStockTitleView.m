//
//  MCStockTitleView.m
//  ZKKLineDemo
//
//  Created by ZK on 2017/8/25.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import "MCStockTitleView.h"
#import "NSString+Common.h"
#import "MacroToolHeader.h"
#import "UIView+Addition.h"
#import <Masonry.h>
#import "MCStockChartUtil.h"

@interface MCStockTitleView ()

// 从左往右的label
@property (nonatomic, strong) UILabel *label_0;
@property (nonatomic, strong) UILabel *label_1;
@property (nonatomic, strong) UILabel *label_2;
@property (nonatomic, strong) UILabel *label_3;

@end

static const CGFloat kDefaultMargin = 8.f;

@implementation MCStockTitleView

+ (instancetype)titleView {
    return [self new];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _label_0 = [self generateLabel];
    [_label_0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(20);
        make.centerY.mas_equalTo(self);
    }];
    
    _label_1 = [self generateLabel];
    [_label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.left.mas_equalTo(_label_0.mas_right).offset(kDefaultMargin);
        make.centerY.mas_equalTo(self);
    }];
    
    _label_2 = [self generateLabel];
    [_label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.left.mas_equalTo(_label_1.mas_right).offset(kDefaultMargin);
        make.centerY.mas_equalTo(self);
    }];
    
    _label_3 = [self generateLabel];
    [_label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.left.mas_equalTo(_label_2.mas_right).offset(kDefaultMargin);
        make.centerY.mas_equalTo(self);
    }];
}

- (UILabel *)generateLabel {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:8];
    label.textColor = KLineTextColor_Gray;
    [self addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (void)updateWithHigh:(CGFloat)high open:(CGFloat)open close:(CGFloat)close low:(CGFloat)low {
    [self updateLabel:_label_0 text:[@"开: " stringByAppendingString:[MCStockChartUtil decimalValue:high]] color: nil];
    [self updateLabel:_label_1 text:[@"高: " stringByAppendingString:[MCStockChartUtil decimalValue:open]] color: nil];
    [self updateLabel:_label_2 text:[@"收: " stringByAppendingString:[MCStockChartUtil decimalValue:close]] color: nil];
    [self updateLabel:_label_3 text:[@"低: " stringByAppendingString:[MCStockChartUtil decimalValue:low]] color: nil];
}

- (void)updateWithVolume:(CGFloat)volume MA5:(CGFloat)MA5 MA10:(CGFloat)MA10 {
    [self updateLabel:_label_0 text:[@"交易量: " stringByAppendingString:[MCStockChartUtil decimalValue:volume count:4]] color: nil];
    [self updateLabel:_label_1 text:[@"MA(5): " stringByAppendingString:[MCStockChartUtil decimalValue:MA5]] color: [UIColor whiteColor]];
    [self updateLabel:_label_2 text:[@"MA(10): " stringByAppendingString:[MCStockChartUtil decimalValue:MA10]] color: [UIColor yellowColor]];
}

- (void)updateWithMACD:(CGFloat)MACD DIF:(CGFloat)DIF DEA:(CGFloat)DEA {
    [self updateLabel:_label_0 text:@"MACD(12, 26, 9)" color: nil];
    [self updateLabel:_label_1 text:[@"DIF: " stringByAppendingString:[MCStockChartUtil decimalValue:DIF]] color: [UIColor whiteColor]];
    [self updateLabel:_label_2 text:[@"DEA: " stringByAppendingString:[MCStockChartUtil decimalValue:DEA]] color: [UIColor yellowColor]];
    [self updateLabel:_label_3 text:[@"MACD: " stringByAppendingString:[MCStockChartUtil decimalValue:MACD]] color: [UIColor redColor]];
}

- (void)updateKDJWithK:(CGFloat)K D:(CGFloat)D J:(CGFloat)J {
    [self updateLabel:_label_0 text:@"KDJ(N:9)" color: nil];
    [self updateLabel:_label_1 text:[@"K: " stringByAppendingString:[MCStockChartUtil decimalValue:K]] color: [UIColor whiteColor]];
    [self updateLabel:_label_2 text:[@"D: " stringByAppendingString:[MCStockChartUtil decimalValue:D]] color: [UIColor yellowColor]];
    [self updateLabel:_label_3 text:[@"J: " stringByAppendingString:[MCStockChartUtil decimalValue:J]] color: [UIColor redColor]];
}

- (void)updateRSIWithRSI6:(CGFloat)RSI6 RSI12:(CGFloat)RSI12 RSI24:(CGFloat)RSI24 {
    [self updateLabel:_label_0 text:@"RSI(6, 12, 24)" color: nil];
    [self updateLabel:_label_1 text:[@"RSI(6): " stringByAppendingString:[MCStockChartUtil decimalValue:RSI6]] color: [UIColor whiteColor]];
    [self updateLabel:_label_2 text:[@"RSI(12): " stringByAppendingString:[MCStockChartUtil decimalValue:RSI12]] color: [UIColor yellowColor]];
    [self updateLabel:_label_3 text:[@"RSI(24): " stringByAppendingString:[MCStockChartUtil decimalValue:RSI24]] color: [UIColor redColor]];
}

- (void)updateLabel:(UILabel *)label text:(NSString *)text color:(UIColor *)color {
    label.text = text;
    if (color) {
        label.textColor = color;
    }
    CGFloat labelWidth = [text stringWidthWithFont:label.font height:CGFLOAT_MAX];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(labelWidth);
    }];
    [UIView animateWithDuration:.15 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
