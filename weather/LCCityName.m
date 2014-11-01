//
//  LCCityName.m
//  WeatherForecast
//
//  Created by lrw on 14-10-27.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "LCCityName.h"

@implementation LCCityName
+(instancetype)city
{
    LCCityName *cityName = [LCCityName new];
    cityName._id = nil;
    cityName.city_num = nil;
    cityName.name = nil;
    return cityName;
}

+(instancetype)cityWithDic:(NSDictionary *)dic
{
   LCCityName *cityName = [LCCityName new];
    [cityName setValuesForKeysWithDictionary:dic];
    return cityName;
}

+(NSString *)getNameBynum:(NSString *)num
{
    LCCityName *cityName = [LCCityName new];
    cityName.city_num = num;
    NSArray *array = [LRWDBHelper findDataFromTable:@"citys" byExample:cityName] ;
    cityName = array.count == 0 ? cityName : [self cityWithDic:[array lastObject]];
    
    
    return cityName.name;
}

+(NSString *)getNumByName:(NSString *)name
{
    LCCityName *cityName = [LCCityName new];
    cityName.name = name;
    NSArray *array = [LRWDBHelper findDataFromTable:@"citys" byExample:cityName] ;
    cityName = array.count == 0 ? cityName : [self cityWithDic:[array lastObject]];
    return cityName.city_num;
}
@end
