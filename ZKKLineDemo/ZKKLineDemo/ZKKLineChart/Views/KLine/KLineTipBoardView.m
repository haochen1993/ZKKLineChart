//
//  KLineTipBoardView.m
//  ChartDemo
//
//  Created by ZhouKang on 16/8/23.
//  Copyright © 2016年 ZhouKang. All rights reserved.
//

#import "KLineTipBoardView.h"

@implementation KLineTipBoardView

#pragma mark - life cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.strockColor = [UIColor redColor];
    self.triangleWidth = 5.0;
    self.radius = 4.0;
    self.hideDuration = 2.5;
    
    self.openingPrice = @"0.0";
    self.close = @"0.0";
    self.high = @"0.0";
    self.low = @"0.0";
    
    self.openColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    self.closeColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    self.highColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    self.lowColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    
    self.font = [UIFont systemFontOfSize:8.0f];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawInContext];
    [self drawText];
}

- (void)drawText {
    NSArray *titles = @[ [@"开盘价：" stringByAppendingString:self.openingPrice],
                         [@"收盘价：" stringByAppendingString:self.close],
                         [@"最高价：" stringByAppendingString:self.high],
                         [@"最低价：" stringByAppendingString:self.low] ];
    NSArray<UIColor *> *colors = @[ self.openColor,
                                    self.closeColor,
                                    self.highColor,
                                    self.lowColor ];
    
    for (int i = 0; i < titles.count; i ++) {
        NSAttributedString *attString = [[NSAttributedString alloc]
                                         initWithString:titles[i] attributes:@{NSFontAttributeName:self.font, NSForegroundColorAttributeName:colors[i]}];
        CGFloat originY = 6 + (4 + self.font.lineHeight) * i;
        
        CGFloat textX = self.arrowInLeft ? self.triangleWidth + 2.5 : self.triangleWidth + 5.5;
        [attString drawInRect:CGRectMake(textX, originY, self.frame.size.width, self.font.lineHeight)];
    }
}

@end
