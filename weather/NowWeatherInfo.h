//
//  WeatherInfo.h
//  WeatherForecast
//
//  Created by ibokan on 14-10-21.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NowWeatherInfo : NSObject
//ID
@property(nonatomic,assign)int ID;
/**
 *  城市名称
 */
@property(nonatomic,retain)NSString *city;
/**
 *  城市代码
 */
@property(nonatomic,retain)NSString *cityid;
/**
 *  气温 如：12
 */
@property(nonatomic,retain)NSString *temp;
/**
 *  风向
 */
@property(nonatomic,retain)NSString *WD;
/**
 *  风力 如：2级
 */
@property(nonatomic,retain)NSString *WS;
/**
 *  湿度  如：25%
 */
@property(nonatomic,retain)NSString *SD;
/**
 *  当前时间 如：14:45
 */
@property(nonatomic,retain)NSString *time;

+(instancetype)nowWeatherInfoWithDict:(NSDictionary*)dict;

-(instancetype)initNowWeatherInfoWithDict:(NSDictionary*)dict;


// 插入操作
-(void) insertNowWeatherInfo:(NowWeatherInfo *) info;
// 根据cityid 查出最新的一条信息（由于请求的数据的time没有年月日，可通过id获取最新数据）
+(NowWeatherInfo *) searchLatestWeatherInfoByCityId:(NSString*)cityid;

+(void)deletDataByCityName:(NSString*)cityId;
@end
