//
//  AppDelegate.h
//  weather
//
//  Created by YiTong.Zhang on 14-10-22.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate,WBHttpRequestDelegate>

@property (strong, nonatomic) UIWindow *window;
/**
 *  接收到的微博HTTP反馈,微博客户端处理完第三方应用的认证申请后向第三方应用回送的处理结果
 */
@property (nonatomic,strong) WBAuthorizeResponse *wbResponse;
@end
