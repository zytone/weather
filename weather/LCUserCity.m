//
//  LCUserCity.m
//  weather
//
//  Created by lrw on 14/11/6.
//  Copyright (c) 2014年 lrw. All rights reserved.
//

#import "LCUserCity.h"
#import "LRWDBHelper/LRWDBHelper.h"

@implementation LCUserCity
+(NSArray *)cityArrayByUserID:(NSString *)userID
{
    LCUserCity *uc = [LCUserCity new];
    uc.userID = userID;
    NSArray *array = [LRWDBHelper findDataFromTable:@"user_city" byExample:uc];
    NSMutableArray *cityArray = nil;
    if(array.count > 0)
    {
        cityArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            LCUserCity *new = [[LCUserCity alloc] init];
            [new setValuesForKeysWithDictionary:dic];
            [cityArray addObject:new];
        }
    }
    return cityArray;
}

+(void)saveOrUpdateCityArrayByUserID:(NSString *)userID cityArray:(NSArray *)cityArray
{
    /**  清空原来的数据  **/
    LCUserCity *uc = [LCUserCity new];
    uc.userID = userID;
    NSArray *array = [LRWDBHelper findDataFromTable:@"user_city" byExample:uc];
    for (NSDictionary *dic in array) {
        LCUserCity *delete = [LCUserCity new];
        [delete setValuesForKeysWithDictionary:dic];
        [LRWDBHelper deleteDataFromTable:@"user_city" byID:delete.ID];
    }
    /**  保存新的数据  **/
    for (LCUserCity *new in cityArray) {
        new.userID = userID;
        [LRWDBHelper addDataToTable:@"user_city" example:new];
    }
}

@end
