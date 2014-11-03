//
//  AppDelegate.m
//  weather
//
//  Created by YiTong.Zhang on 14-10-22.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "Tencent/TencentOpenAPI.framework/Headers/TencentOAuth.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AddCityViewController.h"
#import "RootNavigationController.h"
#import "settingInfo/SettingInfoViewController.h"
#import "LCMainWeatherController.h"
#import "UIImage+BlurImage.h"
#import "JSONKit.h"



#import "LCScrollController.h"
#import "settingInfo/SettingInfoViewController.h"
/**
 *  新浪
 */
#define AppKey @"1990590432"
#define APPSecret @"10b2291dbe3cef695351e080b78a11fe"
#define RedirectURL @"http://www.sina.com"
#define urlForData @"https://api.weibo.com/2/users/show.json"

@implementation AppDelegate

//重写方法
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma mark --新浪微博代理方法--
//接收到微博请求
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    NSLog(@"didReceiveWeiboRequest");
}
//接收到微博的反馈
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        self.wbResponse = (WBAuthorizeResponse *)response;
        if ( self.wbResponse.userID != nil ) {
            [self getUserInfo];
        
            
            
            LCMainWeatherController *main = [LCMainWeatherController new];
            
            RootNavigationController *rootNav = [[RootNavigationController alloc] initWithRootViewController:main];
            
            self.window.rootViewController = rootNav;
            [self.window makeKeyAndVisible];
        }
    }
}
/**
 *  获取用户信息
 */
-(void)getUserInfo
{
    //找用应用程序的代理,获取微博在登陆时返回的数据
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    WBAuthorizeResponse *response = myAppDelegate.wbResponse;
    
    //表示我需要查找uid为当前response.userID的
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    [argument setObject:response.userID forKey:@"uid"];
    
    //根据访问接口令牌，需要获取数据的来源地址，以及该来源地址查询所需要的参数即是上面的字典  发送一个请求
    [WBHttpRequest requestWithAccessToken:response.accessToken url:urlForData httpMethod:@"GET" params:argument delegate:self withTag:@"useInfo"];
}
/**
 *  getUserInfo方法中的requestWithAccessToken执行完之后 自动执行该方法，获取微博返回的结构
 */
-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    
    // 昵称 screen_name  图片路径 avatar_large
    NSDictionary *dict = [result objectFromJSONString];
    NSString *error = dict[@"avatar_large"];
    
    if (error != nil) {
        //创建一个URL
        NSURL *imageUrl = [[NSURL alloc] initWithString:dict[@"avatar_large"]];
        //获取图片的data数据
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        //生成图片
        UIImage *wbImage = [UIImage imageWithData:imageData];
        //将图片的大小修改成80*80
        wbImage = [UIImage changeSizeByOriginImage:wbImage scaleToSize:CGSizeMake(80, 80)];
        //将图片存放在document
        NSString *home = NSHomeDirectory();
        NSString *document = [home stringByAppendingPathComponent:@"Documents"];
        NSString *imgName = @"wbHeaderIcon";
        NSString *imgType = @"png";
        
        [UIImage saveImg:wbImage withImageName:imgName imgType:imgType inDirectory:document];
        
        //将数据保存在偏好设置里面
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //保存图片名
        [defaults setObject:[imgName stringByAppendingFormat:@"%.@",imgType] forKey:@"photoName"];
        //保存昵称
        [defaults setObject:dict[@"nickname"] forKey:@"name"];
    }
    
    NSLog(@"%@",result);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    LoginViewController *login = [LoginViewController new];
    
//    SettingInfoViewController *setting = [SettingInfoViewController new];
//    
    
    
    LCMainWeatherController *main = [LCMainWeatherController new];
    
    RootNavigationController *rootNav = [[RootNavigationController alloc] initWithRootViewController:main];
    
    self.window.rootViewController = rootNav;
    //    self.window.rootViewController = [LoginViewController new];
//    self.window.rootViewController = [RegisterViewController new];
//    self.window.rootViewController = [AddCityViewController new];
    [self.window makeKeyAndVisible];
    
    
    
    //程序启动的时候，注册下新浪AppKep
    [WeiboSDK registerApp:AppKey];
    [WeiboSDK enableDebugMode:YES];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
