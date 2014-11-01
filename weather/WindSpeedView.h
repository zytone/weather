//
//  WindSpeedView.h
//  WeatherForecast
//
//  Created by ibokan on 14-10-27.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailSuperView.h"
#import "NowWeatherInfo.h"

@interface WindSpeedView : DetailSuperView
+(instancetype)windSpeedViewWith:(CGRect) rect;
-(instancetype)initWindSpeedViewWith:(CGRect) rect;
/**
 *  天气模型
 */
@property(nonatomic,retain)NowWeatherInfo *nowWeatherInfo;
@end
