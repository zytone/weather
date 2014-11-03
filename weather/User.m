//
//  User.m
//  weather
//
//  Created by chan on 14-10-23.
//  Copyright (c) 2014年 chan. All rights reserved.
//

#import "User.h"
#import "LRWDBHelper.h"


@implementation User

+(instancetype)user
{
    User *user = [User new];
    
    user.username = nil;
    user.passwd = nil;
    user.name = nil;
    user.phoneNum = nil;
    user.photo = nil;
    
    return user;
}

+(instancetype)userWithDic:(NSDictionary *)dic
{
    User *userName = [User new];
    [userName setValuesForKeysWithDictionary:dic];
    return userName;
}


+ (NSInteger )getCountByUsername:(NSString * )name
{
    User *user = [User new];
    user.username = name;
    
    NSArray *arry  = [LRWDBHelper findDataFromTable:@"user" byExample:user];
    
    return arry.count;
    
}

@end
