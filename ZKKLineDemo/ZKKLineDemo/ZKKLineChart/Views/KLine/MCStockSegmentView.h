//
//  MCStockSegmentView.h
//  ZKKLineDemo
//
//  Created by Zhou Kang on 2017/8/29.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCStockHeader.h"
@class MCStockSegmentView;

@protocol MCStockSegmentViewDelegate <NSObject>

@optional

- (void)stockSegmentView:(MCStockSegmentView *)segmentView didSelectModel:(MCStockSegmentSelectedModel *)model;
- (void)stockSegmentView:(MCStockSegmentView *)segmentView showPopupView:(BOOL)showPopupView;

@end

@interface MCStockSegmentView : UIView

@property (nonatomic, weak) id <MCStockSegmentViewDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isOpening;

+ (instancetype)segmentView;

@end

extern const CGFloat MCStockSegmentViewHeight;
