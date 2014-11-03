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

//横轴显示标签 是
@property (nonatomic, strong) NSArray *hDesc;


//点信息
@property (nonatomic, strong) NSArray *array;
 // 低点
@property (nonatomic, strong) NSArray *arrayLow;

@end
