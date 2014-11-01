//
//  WeatherBriefView.h
//  WeatherForecast
//
//  Created by ibokan on 14-10-22.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NowWeatherInfo.h"
#import "FutureWeekWeahterInfo.h"
// 协议
@protocol WeatherBriefViewDelegate <NSObject>

@optional
// 获取实现天气信息
- (void) weatherBriefViewShareBtnClickWithNowWeather:(NowWeatherInfo *)nowInfo FutureWeekWeahterInfo:(FutureWeekWeahterInfo*) nowFutureInfo;
@end


@interface WeatherBriefView : UIView

+(instancetype)weatherBriefView;
/**
 *  当天天气数据模型
 */
@property(nonatomic,retain)NowWeatherInfo *nowWeatherInfo;
@property(nonatomic,retain)FutureWeekWeahterInfo *futureWeekWeahterInfo;
// 设置代理
@property (nonatomic, strong) id<WeatherBriefViewDelegate> delegate;

@end
