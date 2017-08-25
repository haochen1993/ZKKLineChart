//
//  MCKLineTitleView.h
//  ZKKLineDemo
//
//  Created by ZK on 2017/8/25.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCKLineTitleView : UIView

+ (instancetype)titleView;

- (void)updateWithHigh:(CGFloat)high open:(CGFloat)open close:(CGFloat)close low:(CGFloat)low;

@end
