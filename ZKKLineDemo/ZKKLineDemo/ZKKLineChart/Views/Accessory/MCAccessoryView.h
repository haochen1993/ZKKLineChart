//
//  VolumnView.h
//  ChartDemo
//
//  Created by ZhouKang on 2016/11/17.
//  Copyright © 2016年 ZhouKang. All rights reserved.
//

#import "MCAssistantBaseView.h"
#import "MCStockHeader.h"

@interface MCAccessoryView : MCAssistantBaseView

@property (nonatomic, assign) MCStockAccessoryChartType accessoryChartType;

- (void)showModelInfo:(MCKLineModel *)model type:(MCStockAccessoryChartType)type;

@end

