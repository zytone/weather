//
//  User.h
//  weather
//
//  Created by chan on 14-10-23.
//  Copyright (c) 2014年 chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic,assign) int ID;
@property (nonatomic,copy) NSString* userName;
@property (nonatomic,copy) NSString* passwd;
@property (nonatomic,copy) NSString* name;
@property (nonatomic,copy) NSString* phoneNum;
@property (nonatomic,copy) NSString* photo;


//+ (NSString *)getNumByName:(NSString *)name;
//+ (NSString *)getNameBynum:(NSString *)num;
+ (NSInteger )getCountByUsername:(NSString * )name;
+ (instancetype)user;
+ (instancetype)userWithDic:(NSDictionary *)dic;

@end
