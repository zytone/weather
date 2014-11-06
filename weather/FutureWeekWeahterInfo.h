//
//  FutureWeekWeahterInfo.h
//  WeatherForecast
//
//  Created by ibokan on 14-10-21.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FutureWeekWeahterInfo : NSObject
// ID
@property(nonatomic,assign)int ID;
/**
 *  城市名称
 */
@property(nonatomic,retain)NSString *citynm;
/**
 *  城市ID
 */
@property(nonatomic,retain)NSString *cityid;
/**
 *  城市no ：如 beijing
 */
@property(nonatomic,retain)NSString *cityno;
/**
 *  日期 如：2014-10-21
 */
@property(nonatomic,retain)NSString *days;
/**
 *  星期几 如：星期二
 */
@property(nonatomic,retain)NSString *week;
/**
 *  气温范围 如：17℃/7℃
 */
@property(nonatomic,retain)NSString *temperature;
/**
 *  气温最高 如:17
 */
@property(nonatomic,retain)NSString *temp_high;
/**
 *  气温最底 如:7
 */
@property(nonatomic,retain)NSString *temp_low;
/**
 *  湿度 :0℉/0℉
 */
@property(nonatomic,retain)NSString *humidity;
/**
 *  最高湿度 如：0
 */
@property(nonatomic,retain)NSString *humi_high;
/**
 *  最底湿度 如：0
 */
@property(nonatomic,retain)NSString *humi_low;
/**
 *  天气状况 如：阴转晴
 */
@property(nonatomic,retain)NSString *weather;
/**
 *  风向状况 如：无持续方向
 */
@property(nonatomic,retain)NSString *wind;
/** 
 *  风力的描述 如：微风
 */
@property(nonatomic,retain)NSString *winp;

/**
 *  白天 天气状况图片
 */
@property(nonatomic,retain)NSString *weather_icon;
/**
 *  背景mp4 名称
 */
@property(nonatomic,retain)NSString *weather_icon2;

+(instancetype)futureWeekWeatherInfo:(NSDictionary*)dict;
-(instancetype)initFutureWeekWeatherInfo:(NSDictionary*)dict;

// 插入操作
-(void)insertFutureWeekWeahterInfo:(FutureWeekWeahterInfo *)info;

//根据城市cityid 和date查出date日期（包含date）以后的所有天气数据
+(NSArray*)searchLatestOneWeekWeatherByCityId:(NSString*)cityid  Date:(NSString*)date;
//根据城市id 和count查出 count条天气数据
+(NSArray*)searchLatestFutureWeatherByCityId:(NSString*)cityid  Count:(int)count;

+(FutureWeekWeahterInfo *)searchTodayWeatherByCityName:(NSString *)cityName;

+(void)deletDataByCityName:(NSString*)cityId;
@end
