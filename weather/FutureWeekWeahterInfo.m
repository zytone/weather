//
//  FutureWeekWeahterInfo.m
//  WeatherForecast
//
//  Created by ibokan on 14-10-21.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "FutureWeekWeahterInfo.h"
#import "LRWDBHelper.h"
@implementation FutureWeekWeahterInfo
+(instancetype)futureWeekWeatherInfo:(NSDictionary*)dict
{
    return [[FutureWeekWeahterInfo alloc]initFutureWeekWeatherInfo:dict];
}
-(instancetype)initFutureWeekWeatherInfo:(NSDictionary*)dict
{
    if(self = [super init])
    {
        self.citynm = dict[@"citynm"];
        self.cityid = dict[@"cityid"];
        self.cityno = dict[@"cityno"];
        self.days = dict[@"days"];
        self.week = dict[@"week"];
        self.temperature = dict[@"temperature"];
        self.temp_high = dict[@"temp_high"];
        self.temp_low = dict[@"temp_low"];
        self.humidity = dict[@"humidity"];
        self.humi_high = dict[@"humi_high"];
        self.humi_low = dict[@"humi_low"];
        self.weather = dict[@"weather"]; 
        self.wind = dict[@"wind"];
        self.winp = dict[@"winp"];
        
        self.weather_icon = dict[@"weather_icon"];
        self.weather_icon2 = dict[@"weather_icon2"];
    }
    return self;
}

-(void)insertFutureWeekWeahterInfo:(FutureWeekWeahterInfo *)info
{

    FutureWeekWeahterInfo *exitFWI = [FutureWeekWeahterInfo new];
    exitFWI.week = info.week;
    exitFWI.cityid = info.cityid;
    
    NSArray *array = [LRWDBHelper findDataFromTable:@"week_weather" byExample:exitFWI];
    if (array.count > 0) {//覆盖原来的信息
        NSDictionary *dic = [array lastObject];
        info.ID = [[dic valueForKey:@"ID"] intValue];
        [LRWDBHelper updateOneDataFromTable:@"week_weather" example:info];
    }
    else//没找到，添加新城市，并保存7天天气
    {
       [LRWDBHelper addDataToTable:@"week_weather" example:info];
    }
    
}

+(NSArray *)searchLatestFutureWeatherByCityId:(NSString *)cityid Count:(int)count
{

    FutureWeekWeahterInfo *info = [FutureWeekWeahterInfo new];
    info.cityid = cityid;
    NSMutableArray *result = [NSMutableArray array];
    if (count != 0) {//有设定查找多少条
        int i = 0;
        for (NSDictionary *dic in [LRWDBHelper findDataFromTable:@"week_weather" byExample:info]) {
            FutureWeekWeahterInfo *f = [FutureWeekWeahterInfo new];
            [f setValuesForKeysWithDictionary:dic];
            [result addObject:f];
            i++;
            if (i == count) break;
        }
    }
    else//查找所有
    {
        for (NSDictionary *dic in [LRWDBHelper findDataFromTable:@"week_weather" byExample:info]) {
            FutureWeekWeahterInfo *f = [FutureWeekWeahterInfo new];
            [f setValuesForKeysWithDictionary:dic];
            [result addObject:f];
        }
    }
    return result;
}

+(NSArray *)searchLatestOneWeekWeatherByCityId:(NSString *)cityid Date:(NSString *)date
{
    NSMutableArray *result = [NSMutableArray array];
    FutureWeekWeahterInfo *info = [FutureWeekWeahterInfo new];
    info.days = date;
    for (NSDictionary *dic in [LRWDBHelper findDataFromTable:@"week_weather" byExample:info]) {
        FutureWeekWeahterInfo *f = [FutureWeekWeahterInfo new];
        [f setValuesForKeysWithDictionary:dic];
        [result addObject:f];
    }
    return result;
}

@end


