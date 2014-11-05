//
//  WeekWeather.h
//  WeatherForecast
//
//  Created by ckx on 14-10-25.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailSuperView.h"
#import "NowWeatherInfo.h"
@interface WeekWeatherView : DetailSuperView

+(instancetype)weekWeatherViewWith:(CGRect) rect;
-(instancetype)initWeekWeatherWith:(CGRect) rect;


/**
 *  一周天数组（）
 */
@property(nonatomic,retain)NSArray *data;
@property(nonatomic,retain)NowWeatherInfo *nowInfo;
@end
