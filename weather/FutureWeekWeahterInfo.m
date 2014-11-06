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
        
        NSString *fileName = [[dict[@"weather_icon"] lastPathComponent] stringByDeletingPathExtension];
        self.weather_icon = [NSString stringWithFormat:@"ww%@",fileName];
        self.weather_icon2 = [self getMp4Name:fileName];

    }
    return self;
}
#pragma mark - 根据图片对应背景视频 返回值是带有.mp4后缀
-(NSString*)getMp4Name:(NSString*)fileName
{
    int index = [fileName intValue];
    NSString *aVideoName;
    if(index == 0)
        aVideoName = @"clear.mp4";
    else if(index == 1||index== 18)
        aVideoName = @"overcast.mp4";
    else if(index == 2)
        aVideoName =@"partlycloudy.mp4";
    else if((index >=3&&index<=5)||(index >=7&&index<=8)||index == 19||index == 21)
        aVideoName = @"n_rain.mp4";
    else if((index >=9&&index<=12)||(index >=22&&index<=25))
        aVideoName = @"rain.mp4";
    else if(index == 6||(index >=13&&index<=17)||(index >=26&&index<=28))
        aVideoName = @"snow.mp4";
    else if (index == 20||(index >=29&&index<=30))
        aVideoName =@"wind.mp4";
    else   // 没办法的事
        aVideoName = @"clear.mp4";
    return aVideoName;
}

+(void)deletDataByCityName:(NSString*)cityId
{
    FutureWeekWeahterInfo *now = [FutureWeekWeahterInfo new];
    now.cityid = cityId;
    [LRWDBHelper deleteDataFromTable:@"week_weather" byExample:now];
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
        
        // 排序
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"days" ascending:YES];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [result sortUsingDescriptors:sortDescriptors];
      
    }
    return result;
}

+(FutureWeekWeahterInfo *)searchTodayWeatherByCityName:(NSString *)cityName
{
    
    FutureWeekWeahterInfo *info = [FutureWeekWeahterInfo new];
    info.citynm = cityName;
    NSMutableArray *result = [NSMutableArray array];
    
    
    for (NSDictionary *dic in [LRWDBHelper findDataFromTable:@"week_weather" byExample:info]) {
            FutureWeekWeahterInfo *f = [FutureWeekWeahterInfo new];
            [f setValuesForKeysWithDictionary:dic];
            [result addObject:f];
        }
        
        // 排序
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"days" ascending:YES];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [result sortUsingDescriptors:sortDescriptors];
     if(result.count>0)
     {
      return result[0];
     }
      else
      {
        return nil;
      }
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


