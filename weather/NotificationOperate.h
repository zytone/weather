//
//  NotificationOperate.h
//  PushChat
//
//  Created by YiTong.Zhang on 14-10-27.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationOperate : NSObject

/**
 *  创建一个本地通知
 *
 *  @param message 通知的主要内容
 *  @param info    创建通知者的信息
 *
 *  @return 返回是否创建成功
 */
+ (BOOL) creatLocalNotification : (NSString * )message withUserInfo : (NSDictionary *)info withDate:(NSDate *)aDate;

/**
 *  取消参数aValue对应的本地通知
 *
 *  @param aKey   userInfo中的key值
 *  @param aValue 要取消的userInfo中的value值
 *
 *  @return 返回是否取消成功
 */
+ (BOOL)stop : (NSString *) aKey withValue : (NSString *) aValue;


+ (void)creatNotificationWithInfo: (NSDictionary *)info withTime: (NSDate *)date withMessage: (NSString *) message;


+ (void) stopNotificationWithValue: (NSString *)aValue withKey: (NSString *)aKey;

@end
