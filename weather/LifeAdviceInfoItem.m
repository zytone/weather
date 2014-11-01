//
//  LifeAdviceInfoItem.m
//  WeatherForecast
//
//  Created by ckx on 14-10-26.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "LifeAdviceInfoItem.h"
#import "LRWDBHelper.h"
@implementation LifeAdviceInfoItem
-(void)insertLifeAdviceInfoItem:(LifeAdviceInfoItem *)info
{
    LifeAdviceInfoItem *old = [LifeAdviceInfoItem new];
    old.cityid = info.cityid;
    old.name = info.name;
    
    NSArray *array = [LRWDBHelper findDataFromTable:@"life_advice" byExample:old];
    if (array.count > 0) {//覆盖原来的
        [old setValuesForKeysWithDictionary:array[0]];
        info.ID = old.ID;
        [LRWDBHelper updateOneDataFromTable:@"life_advice" example:info];
    }else//添加新的
    {
       [LRWDBHelper addDataToTable:@"life_advice" example:info];
    }
}

+(NSArray *)searchLifeAdviceInfoItemsByCityId:(NSString *)cityid Date:(NSString *)date
{
    //返回结果数组
    NSMutableArray *result = [NSMutableArray array];
    LifeAdviceInfoItem *item = [LifeAdviceInfoItem new];
    item.cityid = cityid;
    item.date = date;
    NSArray *array = [LRWDBHelper findDataFromTable:@"life_advice" byExample:item];
    for (NSDictionary *dict in array) {
        LifeAdviceInfoItem *lifeItem = [[LifeAdviceInfoItem alloc] init];
        [lifeItem setValuesForKeysWithDictionary:dict];
        [result addObject:lifeItem];
    }
    return result;
}

@end
