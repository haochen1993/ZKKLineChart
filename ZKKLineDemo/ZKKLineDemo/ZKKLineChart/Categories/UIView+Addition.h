//
//  ZKViewController.h
//  ZKDemoPro
//
//  Created by ZK on 17/3/2.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)

@property (nonatomic) CGFloat us_left;

@property (nonatomic) CGFloat us_top;

@property (nonatomic) CGFloat us_right;

@property (nonatomic) CGFloat us_bottom;

@property (nonatomic) CGFloat us_width;

@property (nonatomic) CGFloat us_height;

@property (nonatomic) CGFloat us_centerX;

@property (nonatomic) CGFloat us_centerY;

@property (nonatomic, readonly) CGFloat ttScreenX;

@property (nonatomic, readonly) CGFloat ttScreenY;

@property (nonatomic, readonly) CGFloat screenViewX;

@property (nonatomic, readonly) CGFloat screenViewY;

@property (nonatomic, readonly) CGRect screenFrame;

@property (nonatomic) CGPoint us_origin;

@property (nonatomic) CGSize us_size;

@property (nonatomic, readonly) CGFloat orientationWidth;

@property (nonatomic, readonly) CGFloat orientationHeight;

- (UIView*)descendantOrSelfWithClass:(Class)cls;

- (UIView*)ancestorOrSelfWithClass:(Class)cls;

- (void)removeAllSubviews;

- (CGPoint)offsetFromView:(UIView*)otherView;

- (void)setBorderColor:(UIColor *)borderColor width:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;
@end
