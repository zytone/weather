//
//  LCCityName.h
//  WeatherForecast
//
//  Created by lrw on 14-10-27.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRWDBHelper.h"
@interface LCCityName : NSObject
@property (nonatomic, copy) NSString *city_num;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *province_id;

+ (NSString *)getNumByName:(NSString *)name;
+ (NSString *)getNameBynum:(NSString *)num;
+ (instancetype)city;
+ (instancetype)cityWithDic:(NSDictionary *)dic;
@end
