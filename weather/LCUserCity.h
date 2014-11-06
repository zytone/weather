//
//  LCUserCity.h
//  weather
//
//  Created by lrw on 14/11/6.
//  Copyright (c) 2014年 lrw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCUserCity : NSObject
@property (nonatomic, assign) int ID;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *cityNum;
/**
 查找用户对应的城市队列
 */
+(NSArray *)cityArrayByUserID:(NSString *)userID;
/**
 跟新或者保存用户的城市队列
 */
+(void)saveOrUpdateCityArrayByUserID:(NSString *)userID cityArray:(NSArray *)cityArray;
@end
