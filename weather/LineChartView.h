//
//  LineChartView.h
//  WeatherForecast
//
//  Created by lrw on 14-10-25.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LineChartView : UIView
//横竖轴距离间隔
@property (assign) NSInteger hInterval;
@property (assign) NSInteger vInterval;

//横竖轴显示标签 是
@property (nonatomic, strong) NSArray *hDesc;
@property (nonatomic, strong) NSArray *vDesc;

//点信息
@property (nonatomic, strong) NSArray *array;

@end
