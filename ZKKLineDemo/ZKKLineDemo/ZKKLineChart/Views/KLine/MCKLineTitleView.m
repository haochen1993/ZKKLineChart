//
//  MCKLineTitleView.m
//  ZKKLineDemo
//
//  Created by ZK on 2017/8/25.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import "MCKLineTitleView.h"
#import "NSString+Common.h"
#import "ACMacros.h"
#import "UIView+Addition.h"
#import <Masonry.h>

@interface MCKLineTitleView ()

// 从左往右的label
@property (nonatomic, strong) UILabel *label_0;
@property (nonatomic, strong) UILabel *label_1;
@property (nonatomic, strong) UILabel *label_2;
@property (nonatomic, strong) UILabel *label_3;

@end

@implementation MCKLineTitleView

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
        make.left.mas_equalTo(_label_0.mas_right).offset(10);
        make.centerY.mas_equalTo(self);
    }];
    
    _label_2 = [self generateLabel];
    [_label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.left.mas_equalTo(_label_1.mas_right).offset(10);
        make.centerY.mas_equalTo(self);
    }];
    
    _label_3 = [self generateLabel];
    [_label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.left.mas_equalTo(_label_2.mas_right).offset(10);
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
    NSAssert(high && open && close && low, @"value error");
    [self updateLabel:_label_0 text:[@"开盘价: " stringByAppendingString:[self decimalValue:high]] color: nil];
    [self updateLabel:_label_1 text:[@"最高价: " stringByAppendingString:[self decimalValue:open]] color: nil];
    [self updateLabel:_label_2 text:[@"收盘价: " stringByAppendingString:[self decimalValue:close]] color: nil];
    [self updateLabel:_label_3 text:[@"最低价: " stringByAppendingString:[self decimalValue:low]] color: nil];
}

- (void)updateWithVolume:(CGFloat)volume MA5:(CGFloat)MA5 MA10:(CGFloat)MA10 {
    NSAssert(volume && MA5 && MA10, @"value error");
    [self updateLabel:_label_0 text:[@"交易量: " stringByAppendingString:[self decimalValue:volume]] color: nil];
    [self updateLabel:_label_1 text:[@"MA5: " stringByAppendingString:[self decimalValue:MA5]] color: [UIColor whiteColor]];
    [self updateLabel:_label_2 text:[@"MA10: " stringByAppendingString:[self decimalValue:MA10]] color: [UIColor yellowColor]];
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
    [UIView animateWithDuration:.2 animations:^{
        [self layoutIfNeeded];
    }];
}

- (NSString *)decimalValue:(CGFloat)value {
    NSString *str = nil;
    str = [NSString stringWithFormat:@"%.2f", value];
    return str;
}

@end
