//
//  NotificationOperate.m
//  PushChat
//
//  Created by YiTong.Zhang on 14-10-27.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import "NotificationOperate.h"

@implementation NotificationOperate


#pragma mark - 本地通知
/**
 *  创建一个本地通知
 *
 *  @param message 通知的主要内容
 *  @param info    创建通知者的信息
 *
 *  @return 返回是否创建成功
// */
//+ (BOOL) creatLocalNotification : (NSString * )message withUserInfo : (NSDictionary *)info withDate:(NSDate *)aDate
//{
//    // 添加本地通知
//    UILocalNotification *notification = [[UILocalNotification alloc] init] ;
//    
//    // 设置在多久时候推送的时间
//    NSDate *pushTime = [NSDate dateWithTimeIntervalSinceNow:5];
//    
//    if (notification != nil) {
//        
//        // 设置推送时间
//        notification.fireDate = pushTime;
//        
//        // 设置时区
//        notification.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
//        
//        // 设置重复间隔 一天
//        notification.repeatInterval = kCFCalendarUnitDay;
//        
//        // 设置推送声音
//        notification.soundName = UILocalNotificationDefaultSoundName;
//        
//        // 设置推送内容
//        notification.alertBody = message ;
//        
//        // 显示在icon上的红色数字
//        notification.applicationIconBadgeNumber = 1;
//        
//        // 设置userInfo，以便在注销的时候使用
//        //        NSDictionary *info = [NSDictionary dictionaryWithObject:@"me" forKey:@"zyt"];
//        
//        notification.userInfo = info;
//        
//        // 添加推送到UIApplication
//        UIApplication *application = [UIApplication sharedApplication];
//        
//        [application scheduleLocalNotification:notification];
//        
//        return YES;
//    }
//    else
//    {
//        NSLog(@"创建本地通知失败");
//        return NO;
//    }
//}


/**
 *  取消参数aValue对应的本地通知
 *
 *  @param aKey   userInfo中的key值
 *  @param aValue 要取消的userInfo中的value值
 *
 *  @return 返回是否取消成功
 */
//+ (BOOL)stop : (NSString *) aKey withValue : (NSString *) aValue
//{
//    // 根据这个key来找到对应的通知
//    NSString *LocalNotificationKey = aKey;
//    
//    // 获得 UIApplication
//    UIApplication *app = [UIApplication sharedApplication];
//    
//    //获取本地推送数组
//    NSArray *localArray = [app scheduledLocalNotifications];
//    
//    if (localArray) {
//        for (UILocalNotification *noti in localArray) {
//            
//            // 拿出对应的那些用户信息
//            NSDictionary *dict = noti.userInfo;
//            
//            if (dict) {
//                // 取出对应key值的value
//                NSString *inKey = [dict objectForKey:LocalNotificationKey];
//                
//                // 对比是否为要取消的通知
//                if ([inKey isEqualToString:aValue]) {
//                    
//                    // 取消通知
//                    [app cancelLocalNotification:noti];
//                    
//                    return YES;
//                }
//            }
//        }
//        
//    }
//    
//    return NO;
//}


// 停止本地推送
//- (void) stopLocalNotification
//{
//    NSString *LocalNotificationKey = @"zyt";
//    
//    // 获得application
//    UIApplication *application = [UIApplication sharedApplication];
//    
//    //  获取本地推送数据的数组
//    NSArray *localArr = [application scheduledLocalNotifications];
//    
//    // 声明本地推送
//    UILocalNotification *localNotification;
//    
//    // 如果有本地推送
//    if (localArr) {
//        
//        // 拿出本地推送的信息
//        for (UILocalNotification *notification in localArr) {
//            
//            // 拿出本地推送的信息的内容
//            NSDictionary *dic = notification.userInfo;
//            
//            if (dic) {
//                
//                NSString *inKey = [dic objectForKey:LocalNotificationKey];
//                
//                NSLog(@"inKey: %@",inKey);
//                
//                if ([inKey isEqualToString:@"me"]) {
//                    
//                    if (localNotification ) {
//                        //                        [localNotification release];
//                        //                        NSLog(@"%d",[localNotification retainCount]);
//                        //                        NSLog(@"%@",localNotification);
//                        
//                        localNotification = nil;
//                    }
//                    
//                    NSLog(@"接收了notification！~");
//                    //                    localNotification = [notification retain];
//                    //                    localNotification = notification;
//                    
//                    break;
//                    
//                }
//                
//            }
//        }
//    }
//    
//    // 判断是否已经找到了相同的key的推送
//    if (!localNotification) {
//        
//        NSLog(@"这里来个初始化");
//        
//        // 不存在初始化
//        localNotification = [[UILocalNotification alloc] init];
//        
//    }
//    
//    if (localNotification) {
//        
//        NSLog(@"这里取消了推送");
//        
//        // 不推送 取消推送
//        [application cancelLocalNotification:localNotification];
//        
//        //        [localNotification release];
//        
//        return ;
//        
//    }
//    
//    
//}


+ (void)creatNotificationWithInfo: (NSDictionary *)info withTime: (NSDate *)date withMessage: (NSString *) message
{
    // 添加本地通知
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    
    if (notification!=nil)
    {
//        NSDate *now = [NSDate date];
        // 设置提醒时间，倒计时以秒为单位。以下是从现在开始55秒以后通知
        //        notification.fireDate=[now dateByAddingTimeInterval:5];
        notification.fireDate = date;
        
        // 设置重复间隔 一天
        notification.repeatInterval = kCFCalendarUnitDay;
        
        // 设置时区，使用本地时区
        notification.timeZone=[NSTimeZone defaultTimeZone];
        
        // 设置提示的文字
        //        notification.alertBody=@"时间到了，洗洗睡吧";
        notification.alertBody = message;
        
        // 设置提示音，使用默认的
        notification.soundName= UILocalNotificationDefaultSoundName;
        
        // 锁屏后提示文字，一般来说，都会设置与alertBody一样
        notification.alertAction=NSLocalizedString(message, nil);
        
        // 这个通知到时间时，你的应用程序右上角显示的数字. 获取当前的数字+1
        notification.applicationIconBadgeNumber += 1;
        
        NSLog(@"number : %d",notification.applicationIconBadgeNumber);
        
        //给这个通知增加key 便于半路取消。nfkey这个key是自己随便写的，还有notificationtag也是自己定义的ID。假如你的通知不会在还没到时间的时候手动取消，那下面的两行代码你可以不用写了。取消通知的时候判断key和ID相同的就是同一个通知了。
        //        NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:notificationtag],@"nfkey",nil];
        //        NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:@"test",@"nfkey",nil];
        
        NSLog(@"date : %@",date);
        
        [notification setUserInfo:info];
        
        // 由于只有一个通知，所以我们可以先清掉所有的通知，再加新的通知
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        // 启用这个通知
        [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
        // 创建了就要学会释放。如果不加这一句，通知到时间了，发现顶部通知栏提示的地方有了，然后你通过通知栏进去，然后你发现通知栏里边还有这个提示，除非你手动清除

        
//        NSLog(@"retainCount : %d",notification.retainCount);
        
    }
    [notification release];
}

+ (void) stopNotificationWithValue: (NSString *)aValue withKey: (NSString *)aKey
{
    // 手动删除通知
    // 这里我们要根据我们添加时设置的key和自定义的ID来删
    NSArray *narry=[[UIApplication sharedApplication] scheduledLocalNotifications];
    NSUInteger acount=[narry count];
    if (acount>0)
    {
        // 遍历找到对应nfkey和notificationtag的通知
        for (int i=0; i<acount; i++)   
        {
            UILocalNotification *myUILocalNotification = [narry objectAtIndex:i];
            NSDictionary *userInfo = myUILocalNotification.userInfo;
            //            NSString *obj = [userInfo objectForKey:@"nfkey"];
            NSString *obj = [userInfo objectForKey:aKey];
//            int mytag=[obj intValue];
            //            if (mytag==notificationtag)
            if ([obj isEqualToString:aValue] == 1 )
            {
                NSLog(@"找到了！~ 取消中。。。。");
                
                // 删除本地通知
                [[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
                break;
            }
        }
    }
}



@end
