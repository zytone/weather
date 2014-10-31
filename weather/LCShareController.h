//
//  LCShareController.h
//  WeatherForecast
//
//  Created by lrw on 14/10/30.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FutureWeekWeahterInfo,NowWeatherInfo;
@interface LCShareController : UIViewController
+(instancetype) shareWithView:(UIView *)view;

-(void)showShareViewWithFutureWeekWeahterInfo:(FutureWeekWeahterInfo *)futureWeekWeahterInfo NowWeatherInfo:(NowWeatherInfo *)nowWeatherInfo;

#warning 这方法只是添加一个分享按钮，以后要删除的
-(void) addBtn;
@end
