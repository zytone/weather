//
//  WeatherInfo.m
//  WeatherForecast
//
//  Created by ibokan on 14-10-21.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "NowWeatherInfo.h"
#import "LRWDBHelper.h"

@implementation NowWeatherInfo

+(instancetype)nowWeatherInfoWithDict:(NSDictionary *)dict
{
    
    return [[NowWeatherInfo alloc]initNowWeatherInfoWithDict:dict];
}
-(instancetype)initNowWeatherInfoWithDict:(NSDictionary *)dict
{
    if(self= [super init])
    {
        self.city = dict[@"city"];
        self.cityid = dict[@"cityid"];
        self.temp = dict[@"temp"];
        self.time = dict[@"time"];
        self.SD = dict[@"SD"];
        self.WD = dict[@"WD"];
        self.WS = dict[@"WS"];
    }
    return self;
}

+(void)deletDataByCityName:(NSString*)cityId
{
    NowWeatherInfo *now = [NowWeatherInfo new];
    now.cityid = cityId;
    [LRWDBHelper deleteDataFromTable:@"now_weather" byExample:now];
}

-(void)insertNowWeatherInfo:(NowWeatherInfo *)info
{
    NowWeatherInfo *old = [NowWeatherInfo new];
    old.cityid = info.cityid;
    
    NSArray *array = [LRWDBHelper findDataFromTable:@"now_weather" byExample:old];
    if (array.count > 0) {//覆盖原来的
        [old setValuesForKeysWithDictionary:array[0]];
        info.ID = old.ID;
        [LRWDBHelper updateOneDataFromTable:@"now_weather" example:info];
    }else//添加新的
    {
        [LRWDBHelper addDataToTable:@"now_weather" example:info];
    }
}

+(NowWeatherInfo *)searchLatestWeatherInfoByCityId:(NSString *)cityid
{
    NowWeatherInfo *nowWeatherInfo = [NowWeatherInfo new];
    nowWeatherInfo.cityid = cityid;
    NSArray *array = [LRWDBHelper findDataFromTable:@"now_weather" byExample:nowWeatherInfo];
    if (array.count > 0) {
        [nowWeatherInfo setValuesForKeysWithDictionary:[array lastObject]];
        return nowWeatherInfo;
    }
    else
    {
        return nil;
    }
}
+(NowWeatherInfo *) searchLatestWeatherInfoByCityName:(NSString*)cityName
{
    NowWeatherInfo *nowWeatherInfo = [NowWeatherInfo new];
    nowWeatherInfo.city = cityName;
    NSArray *array = [LRWDBHelper findDataFromTable:@"now_weather" byExample:nowWeatherInfo];
    if (array.count > 0) {
        [nowWeatherInfo setValuesForKeysWithDictionary:[array lastObject]];
        return nowWeatherInfo;
    }
    else
    {
        return nil;
    }
}

@end
