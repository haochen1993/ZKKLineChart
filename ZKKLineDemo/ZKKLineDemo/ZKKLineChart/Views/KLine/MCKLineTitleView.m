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
        make.top.left.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    
    _label_1 = [self generateLabel];
    [_label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(_label_0.mas_right).offset(10);
    }];
    
    _label_2 = [self generateLabel];
    [_label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
        make.left.mas_equalTo(_label_1.mas_right).offset(10);
    }];
    
    _label_3 = [self generateLabel];
    [_label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
        make.left.mas_equalTo(_label_2.mas_right).offset(10);
    }];
}

- (UILabel *)generateLabel {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = KLineTextColor_Gray;
    [self addSubview:label];
    label.backgroundColor = [UIColor redColor];
    return label;
}

- (void)updateWithHigh:(CGFloat)high open:(CGFloat)open close:(CGFloat)close lower:(CGFloat)lower {
    
}

@end
