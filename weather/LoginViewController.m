//
//  LoginViewController.m
//  weather
//
//  Created by YiTong.Zhang on 14-10-22.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import "LoginViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "UIImage+BlurImage.h"
#import "LRWDBHelper.h"
#import "RegisterViewController.h"
#import "MBProgressHUD+MJ.h"
#import "settingInfo/SettingInfoViewController.h"
#import "RetrievePasswdByEmailViewController.h"
#import "LRWDBHelper/LRWDBHelper.h"
//#import "LCMainWeatherController.h"

//左右边距
#define PADDING 15
//文本框的高度
#define TEXTFILEDHEIGHT 44
//头像到账号框的距离
#define DISTANCE 30
//文本框之间的间距
#define TEXTPADDING 10

/**
 *  腾讯第三方登陆相关
 */
#define AppId @"222222"
/**
 *  新浪微博第三方登陆相关
 */
#define AppKey @"1990590432"
#define APPSecret @"10b2291dbe3cef695351e080b78a11fe"
//应用回调页,在进行 Oauth2.0 登录认证时 所用。对于 Mobile 客户端应用来说,是不存在 Server 的,故此处 的应用回调页地址只要与新浪微博开放平台->我的应用->应用信息->高级应用->授权设置->应用回调页中的 url 地址保持一致就 可以了
#define RedirectURL @"http://www.sina.com"
#define urlForData @"https://api.weibo.com/2/users/show.json"
@interface LoginViewController ()<TencentSessionDelegate,UITextFieldDelegate>
/**
 *  头像
 */
@property (nonatomic,weak) UIImageView *head;
/**
 *  用户输入框
 */
@property (nonatomic,weak) UITextField *userFiled;
/**
 *  密码输入框
 */
@property (nonatomic,weak) UITextField *passwordFiled;
/**
 *  登陆按钮
 */
@property (nonatomic,weak) UIButton *loginBtn;
/**
 *  注册按钮
 */
@property (nonatomic,weak) UIButton *registerBtn;
/**
 *  忘记密码按钮
 */
@property (nonatomic,weak) UIButton *forgetBtn;
/**
 *  第三方登陆按钮：QQ
 */
@property (nonatomic,weak) UIButton *QQLogin;
/**
 *  第三方登陆：微博
 */
@property (nonatomic,weak) UIButton *WBLogin;
@property (nonatomic,strong) TencentOAuth *tencent;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    self.view.backgroundColor = [UIColor colorWithRed:244/254.0 green:244/254.0 blue:244/254.0 alpha:1];
    //    self.view.backgroundColor = [UIColor clearColor];
    
    // 针对ios7的适配

    
    // 设置View的背景 zyt
//    self.view.backgroundColor = [UIColor colorWithRed:244/254.0 green:244/254.0 blue:244/254.0 alpha:1];
    
    //  ------  页面切换
    
//    self.navigationController.navigationBar.hidden = NO;
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
//    self.navigationController.delegate = self;
    
    // 下面2种都可以去掉系统的下划线
    //    self.navigationController.navigationBar.clipsToBounds = YES;
    //    [self.navigationController.navigationBar.layer setMasksToBounds:YES];
    
//    [self setNavBar];
    
    //  ------  页面切换 end -------------
    
    //背景层  5 6
    UIImage *bgImg = [UIImage imageNamed:@"bg6@2x.jpg"];
    bgImg =  [bgImg blurredImageWithRadius:100 iterations:1 tintColor:[UIColor whiteColor]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:bgImg];
    imgView.frame = self.view.bounds;
    [self.view addSubview:imgView];
    [self.view sendSubviewToBack:imgView];
    // 容器层
    UIView *container = [[UIView alloc]init];
    container.frame = self.view.bounds;
    container.backgroundColor = [UIColor clearColor];
    [self.view addSubview:container];
    
    // 1、头像
    UIImage *headImage = [UIImage imageNamed:@"right_drawer_head_unlogin_press"];
    CGFloat headW = headImage.size.width - 70;
    CGFloat headH = headImage.size.height - 70;
    CGFloat headX = (self.view.frame.size.width - headW)*0.5;
    CGFloat headY = 75;
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(headX, headY, headW, headH)];
    headView.image = headImage;
    headView.layer.masksToBounds = YES;
    headView.layer.cornerRadius = (headImage.size.width-70)*0.5;
    self.head = headView;
    [container addSubview:headView];
    
    //头像圆环层
    UIImage *layerImg = [UIImage ImageWithColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5] frame:CGRectMake(0, 0, (headImage.size.width - 70) +15, (headImage.size.width - 70 )+15)];
    layerImg  = [layerImg blurredImageWithRadius:1000 iterations:1 tintColor:[UIColor whiteColor]];
    UIImageView *layerView = [[UIImageView alloc] initWithImage:layerImg];
    layerView.center = headView.center;
    layerView.layer.masksToBounds = YES;
    layerView.layer.cornerRadius = layerImg.size.width*0.5;
    [container addSubview:layerView];
    [container sendSubviewToBack:layerView];
    
    // 2、账号
    
    
    CGFloat padding = PADDING;//左右边距
    CGFloat userW = self.view.frame.size.width - padding *2;
    CGFloat userH = TEXTFILEDHEIGHT;
    CGFloat userX = PADDING;
    CGFloat userY = CGRectGetMaxY(headView.frame) + DISTANCE;
    UITextField *userFiled = [[UITextField alloc] initWithFrame:CGRectMake(userX, userY, userW, userH)];
    userFiled.backgroundColor = [UIColor clearColor];
    userFiled.tag = 1;
    userFiled.placeholder = @"请输入你的邮箱";
    userFiled.clearButtonMode = UITextFieldViewModeUnlessEditing;
    userFiled.delegate = self;
    
    UIView *userView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, userH)];
    UIImageView *userImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_user_os7@2x"]];
    [userView addSubview:userImageView];
    
    userFiled.leftView = userView;
    userFiled.leftViewMode = UITextFieldViewModeAlways;
    self.userFiled = userFiled;
    [container addSubview:userFiled];
    
    //user分隔线
    UIView *userDividingLine = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(userFiled.frame), self.view.frame.size.width - 15 *2, 1)];
    userDividingLine.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3];
    [container addSubview:userDividingLine];
    
    // 3、密码
    CGFloat passwFiledW = self.view.frame.size.width - padding *2;
    CGFloat passwFiledH = TEXTFILEDHEIGHT;
    CGFloat passwFiledX = PADDING;
    CGFloat passwFiledY = CGRectGetMaxY(userFiled.frame) + TEXTPADDING;
    UITextField *passwFiled = [[UITextField alloc] initWithFrame:CGRectMake(passwFiledX, passwFiledY, passwFiledW, passwFiledH)];
    passwFiled.backgroundColor = [UIColor clearColor];
    passwFiled.placeholder = @"请输入你的密码";
    passwFiled.secureTextEntry = YES;
    passwFiled.tag = 2;
    passwFiled.clearButtonMode = UITextFieldViewModeUnlessEditing;
    
    UIView *passwView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, userH)];
    UIImageView *passImageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_key_os7@2x"]];
    [passwView addSubview:passImageView];
    
    
    passwFiled.leftView = passwView;
    passwFiled.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordFiled = passwFiled;
    [container addSubview:passwFiled];
    
    //passwd分隔线
    UIView *passwDividingLine = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(passwFiled.frame), self.view.frame.size.width - 15 *2, 1)];
    passwDividingLine.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3];
    [container addSubview:passwDividingLine];
    
    
    // 4、登陆按钮
    CGFloat loginW = userW;
    CGFloat loginH = userH;
    CGFloat loginX = PADDING;
    CGFloat loginY = CGRectGetMaxY(passwFiled.frame) +DISTANCE;
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(loginX, loginY, loginW, loginH)];
    loginBtn.backgroundColor = [UIColor colorWithRed:0.3 green:0.5 blue:0.8 alpha:0.8];
    
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    loginBtn.userInteractionEnabled = YES;
    loginBtn.enabled = YES;
    [container addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    
    //第三方登陆
    CGFloat tipW = self.view.frame.size.width*0.5;
    CGFloat tipH = 40;
    CGFloat tipX = PADDING;
    CGFloat tipY = CGRectGetMaxY(loginBtn.frame) +PADDING;
    UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(tipX, tipY, tipW, tipH)];
    tipLable.text = @"其他登陆：";
    [tipLable setFont:[UIFont systemFontOfSize:14]];
    [container addSubview:tipLable];
    
    
    UIImage *WBImg = [UIImage imageNamed:@"wb"];
    CGFloat WBW = WBImg.size.width;
    CGFloat WBH = WBImg.size.height;
    CGFloat WBX = 100;
    CGFloat WBY = CGRectGetMaxY(tipLable.frame);
    UIButton *WBBtn = [[UIButton alloc] initWithFrame:CGRectMake(WBX, WBY, WBW, WBH)];
    [WBBtn setImage:WBImg forState:UIControlStateNormal];
    [WBBtn addTarget:self action:@selector(wbLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:WBBtn];
    self.WBLogin = WBBtn;
    
    UIImage *QQImg = [UIImage imageNamed:@"QQ"];
    CGFloat QQW = QQImg.size.width;
    CGFloat QQH = QQImg.size.height;
    CGFloat QQX = CGRectGetMaxX(WBBtn.frame) + DISTANCE;
    CGFloat QQY = WBY;
    UIButton *QQBtn = [[UIButton alloc] initWithFrame:CGRectMake(QQX, QQY, QQW, QQH)];
    [QQBtn setImage:QQImg forState:UIControlStateNormal];
    [QQBtn addTarget:self action:@selector(qqLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:QQBtn];
    self.QQLogin = QQBtn;
    
    // 注册  忘记密码
    CGFloat containerW = self.view.frame.size.width * 0.5;
    CGFloat containerH = 30;
    CGFloat containerX = containerW*0.5;
    CGFloat containerY = self.view.frame.size.height - containerH;
    UIView *contain = [[UIView alloc] initWithFrame:CGRectMake(containerX, containerY, containerW, containerH)];
    [container addSubview:contain];
    
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, containerW*0.5, containerH)];
    [registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTitleColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3] forState:UIControlStateHighlighted];
    [contain addSubview:registerBtn];
    self.registerBtn = registerBtn;
    
    UIButton *forgetBtn = [[UIButton alloc] initWithFrame:CGRectMake(containerW*0.5, 0, containerW*0.5, containerH)];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetBtn addTarget:self action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn setTitleColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3] forState:UIControlStateHighlighted];
    [contain addSubview:forgetBtn];
    self.forgetBtn = forgetBtn;
    
    //分割线
    UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(containerW*0.5, containerH*0.2,1, containerH *0.6)];
    separateLine.backgroundColor =[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3];
    [contain addSubview:separateLine];
    
    //手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [container addGestureRecognizer:tap];
    
    //初始化QQ
    self.tencent = [[TencentOAuth alloc] initWithAppId:AppId andDelegate:self];
    
    //增加输入框文本长度监听
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        //监听文本改变 修改按钮状态
        if (![self.userFiled.text isEqualToString:@""]
            && ![self.passwordFiled.text isEqualToString:@""]) {
            self.loginBtn.enabled = YES;
            
        }else
        {
            self.loginBtn.enabled = NO;
            
        }
        
        
    }];
    
    //以下两个通知：修改图片状态
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidBeginEditingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        UITextField *currentText = (UITextField *)note.object;
        UIImageView *leftView = [currentText.leftView.subviews lastObject];
        (currentText.tag == 1) ? (leftView.image = [UIImage imageNamed:@"login_user_highlighted_os7@2x"]): (leftView.image = [UIImage imageNamed:@"login_key_highlighted_os7@2x"]) ;
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        UITextField *currentText = (UITextField *)note.object;
        UIImageView *leftView = [currentText.leftView.subviews lastObject];
        (currentText.tag == 1) ? (leftView.image = [UIImage imageNamed:@"login_user_os7@2x"]): (leftView.image = [UIImage imageNamed:@"login_key_os7@2x"]) ;
    }];
#warning 暂时固定用户名、密码
//    self.userFiled.text = @"admin";
//    self.passwordFiled.text = @"123";
    
    // 添加退出登录也的按钮
    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [quitBtn setImage:[UIImage imageNamed:@"banner-activity-close.png"] forState:UIControlStateNormal];
    quitBtn.frame = CGRectMake(10, 20, 32, 32);
    quitBtn.alpha = 0.5;
    [quitBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    quitBtn.backgroundColor = [UIColor whiteColor];
    [container addSubview:quitBtn];
    
}


#pragma mark --本页按钮点击--
//登陆点击
-(void)loginBtnClick:(UIButton *)btn
{
    NSMutableDictionary *dict = [self searchDataFromDbByString:self.userFiled.text];
    if (dict.count == 0) {
        [self shakeView:self.userFiled];
        [self showTipMessage:@"用户名不存在"];
        return;
    }
    if (![self.passwordFiled.text isEqualToString:dict[@"passwd"]]) {
        [self shakeView:self.passwordFiled];
        [self showTipMessage:@"密码错误"];
        return;
    }
    
    [MBProgressHUD showMessage:@"正在登陆..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#warning 在这里跳转至主页面
        [MBProgressHUD hideHUD];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
        //将数据保存在偏好设置里面
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        //保存用户名
//        [defaults setObject:self.userFiled.text forKey:@"userName"];
//        //保存图片名
//        [defaults setObject:@"head.jpeg" forKey:@"photoName"];
//        
//        [defaults synchronize];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        // 设置保存的key
        NSString *key = @"userInfo";
        NSString *userKey = @"userName";
        NSString *photoKey = @"photoName";
        
        // 获取输入的文本
        NSString *name = self.userFiled.text;
        
        
#warning 登录这里设置了默认头像
        
        User *userInfo = [[User alloc] init];
        userInfo.userName = name;
        
        NSDictionary *dicUser = [[LRWDBHelper findDataFromTable:@"user" byExample:userInfo] lastObject];
        
//        NSDictionary *dicUser = [arr lastObject];

        
        NSString *photo = dicUser[@"photo"];
        
        NSDictionary *dic = @{userKey: name, photoKey : photo};
        
        // 设置数据
        [userDefaults setObject:dic forKey:key];
        
        // 更新数据，本地的
        [userDefaults synchronize];
        
        NSDictionary *dict = [userDefaults objectForKey:key];
//        NSLog(@"这里是！~！~%@",dict);
        
//        NSNotificationCenter *notifC = [NSNotificationCenter defaultCenter];
        // 发布一个通知，用于更新数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userChange" object:nil];
        
        
    });
    [self.view endEditing:YES];
//    NSLog(@"%@",dict);
}
//忘记密码点击
-(void)forgetBtnClick:(UIButton *)btn
{
#warning 忘记密码跳转
    [self pushToRetrievePasswd];
}

//注册点击
-(void)registerBtnClick:(UIButton *)btn
{
#warning 注册点击跳转
    [self pushToRegister];
}
/**
 *  退出键盘
 */
-(void)tapAction
{
    [self.view endEditing:YES];
}

/**
 *  微博登录
 *
 */
- (void) loginByWeiboPopToRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark --以下是微博登陆--
/**
 *  微博登陆
 */
-(void)wbLoginBtnClick:(UIButton *)btn
{
    
    //创建授权请求，发送请求
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = RedirectURL;
    request.scope = @"all";
    request.userInfo = nil;
    [WeiboSDK sendRequest:request];
    
}



#pragma mark --以下是QQ登陆--
/**
 *  QQ登陆
 */
-(void)qqLoginBtnClick:(UIButton *)btn
{
    [self beginQQLogin];
    //需要取得的权限
    NSArray *permissions = [NSArray arrayWithObjects:@"get_user_info",@"add_t", nil];
    [self.tencent authorize:permissions inSafari:NO];
}
/**
 *  QQ登陆前的准备工作
 */
-(void)beginQQLogin
{
    //取出上次的授权
    NSString *home = NSHomeDirectory();
    NSString *path = [home stringByAppendingPathComponent:@"qqData"];
    
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:path];
    if (data.length) {
        //        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        //        NSString *accessToken = [unarchiver decodeObjectForKey:@"accessToken"];
        //        NSString *openId  = [unarchiver decodeObjectForKey:@"openId"];
        //        NSDate *expirationDate = [unarchiver decodeObjectForKey:@"expirationDate"];
        //        self.tencent.accessToken = accessToken;
        //        self.tencent.openId = openId;
        //        self.tencent.expirationDate = expirationDate;
    }
}
#pragma mark --腾讯回调协议--
/**
 *  成功登陆
 */
-(void)tencentDidLogin
{
    //登陆成功之后，将授权归档（持久化）
    //获得沙盒根路径
    //    NSString *home = NSHomeDirectory();
    //    NSString *path = [home stringByAppendingPathComponent:@"qqData"];
    //
    //    //如果文件不存在，则创建
    //    NSFileManager *fileManage = [NSFileManager defaultManager];
    //    if (![fileManage fileExistsAtPath:path]) {
    //        [fileManage createFileAtPath:path contents:nil attributes:nil];
    //    }
    //
    //    NSMutableData *data = [NSMutableData data];
    //    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //    [archiver encodeObject:self.tencent.accessToken forKey:@"accessToken"];
    //    [archiver encodeObject:self.tencent.openId forKey:@"openId"];
    //    [archiver encodeObject:self.tencent.expirationDate forKey:@"expirationDate"];
    //    //完成归档
    //    [archiver finishEncoding];
    //    [data writeToFile:path atomically:YES];
    
    //获取用户信息
    [self.tencent getUserInfo];
    [self showTipMessage:@"登陆成功"];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/**
 *  网络连接不通
 */
-(void)tencentDidNotNetWork
{
    [self showTipMessage:@"网络连接失败"];
}
/**
 *  登陆失败
 */
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {
        [self showTipMessage:@"取消登陆"];
    }
}

/**
 *  获取用户信息,将其持久化
 *
 *  @param response 腾讯返回的数据
 */
-(void)getUserInfoResponse:(APIResponse *)response
{
    //创建一个URL
    NSURL *imageUrl = [[NSURL alloc] initWithString:response.jsonResponse[@"figureurl_qq_2"]];
    //获取图片的data数据
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    //生成图片
    UIImage *QQImage = [UIImage imageWithData:imageData];
    //将图片的大小修改成80*80
    QQImage = [UIImage changeSizeByOriginImage:QQImage scaleToSize:CGSizeMake(80, 80)];
    //将图片存放在document
    NSString *home = NSHomeDirectory();
    NSString *document = [home stringByAppendingPathComponent:@"Documents"];
    NSString *imgName = @"qqHeaderIcon";
    NSString *imgType = @"png";
    
    [UIImage saveImg:QQImage withImageName:imgName imgType:imgType inDirectory:document];
    
    //将数据保存在偏好设置里面
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //保存图片名
    [defaults setObject:[imgName stringByAppendingFormat:@"%.@",imgType] forKey:@"photoName"];
    //保存昵称
    [defaults setObject:response.jsonResponse[@"nickname"] forKey:@"name"];
}



#pragma mark --提示信息--
/**
 *  弹出一个提示信息
 *
 *  @param message 传入信息
 */
-(void)showTipMessage:(NSString *)message
{
    UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    tipLable.center = self.view.center;
    tipLable.text = message;
    tipLable.alpha = 0;
    tipLable.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
    tipLable.textAlignment = NSTextAlignmentCenter;
    tipLable.layer.cornerRadius = 5;
    tipLable.layer.masksToBounds = YES;
    [self.view addSubview:tipLable];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        tipLable.alpha = 1;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            tipLable.alpha = 0;
        } completion:^(BOOL finished) {
            [tipLable removeFromSuperview];
        }];
        
    }];
}

/**
 *  让一个View有一个震动的效果
 *
 *  @param view 需要震动的View
 */
-(void)shakeView:(UIView *)view
{
    CGPoint c ;
    CGPoint l ;
    CGPoint r ;
    int ra = arc4random()%2;
    if (ra == 0) {
        c = view.center;
        l = CGPointMake(c.x-10, c.y);
        r = CGPointMake(c.x+10, c.y);
    }
    else if (ra == 1) {
        c = view.center;
        l = CGPointMake(c.x+10, c.y);
        r = CGPointMake(c.x-10, c.y);
    }
    
    
    CAKeyframeAnimation  *ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    ani.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:l],[NSValue valueWithCGPoint:c],[NSValue valueWithCGPoint:r],[NSValue valueWithCGPoint:c],[NSValue valueWithCGPoint:l],[NSValue valueWithCGPoint:c], nil];
    
    [view.layer addAnimation:ani forKey:@"ani-1"];
}

#pragma mark --数据库相关--
/**
 根据用户名取查找数据
 */
-(NSMutableDictionary *)searchDataFromDbByString:(NSString *)sqlString
{
    //防止将当字符串为空的时候将数据库的所以信息查出
    if ([sqlString isEqualToString:@""]) {
        NSLog(@"用户名没有输入");
        return nil;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    sqlite3 *db = [LRWDBHelper open];
    //传入一个数组用于存放查询结果数据
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM USER WHERE userName = '%@'",sqlString];
    char *error;
    sqlite3_exec(db, [sql UTF8String], CallBack, (__bridge void *)(dict), &error);
    NSLog(@"%s",error);
    [LRWDBHelper close];
    return dict;
}

/**
 *  每查到一条记录，就调用一次这个回调函数
 *  @param para        sqlite3_exec()传来的参数
 *  @param count       一条记录字段数
 *  @param char**value 是个关键值，查出来的数据都保存在这里，它实际上是个1维数组
 *  @param char**key   跟column_value是对应的，表示这个字段的字段名称
 */
int CallBack(void* para,int count ,char**value,char**key)
{
    NSMutableDictionary *dic = (__bridge NSMutableDictionary *)(para);
    
    for (int i = 0; i < count; i++) {
        [dic setObject:[NSString stringWithUTF8String: value[i] == nil ? "" : value[i] ]
                forKey:[NSString stringWithUTF8String:key[i]]];
    }
    return 0;
}

#pragma mark - nav 跳转
/**
 *  跳到注册页面
 */
- (void) pushToRegister
{
    RegisterViewController *reg = [[RegisterViewController alloc] init];
    
    reg.title = @"注册";
    
    [self.navigationController pushViewController:reg animated:YES];
}
/**
 *  跳到忘记密码页面
 */
- (void) pushToRetrievePasswd
{
    RetrievePasswdByEmailViewController *re = [RetrievePasswdByEmailViewController new];
    
    re.title = @"找回密码";
    
    [self.navigationController pushViewController:re animated:YES];
}

/**
 *  设置nav上面的bar
 */
- (void) setNavBar
{
    //    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(leftBtnClick:)];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick:)];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
}

/**
 *  bar上面的左返回键，使用的navigationController的时候调用，模态的时候不调用
 */
- (void)leftBtnClick: (id)sender
{
    //    CATransition *animation = [CATransition animation];
    //
    //    animation.delegate = self;
    //    animation.duration = 0.5f;
    //    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //
    //    animation.type = kCATransitionFade;
    //    animation.subtype = kCATransitionFromTop;
    
    SettingInfoViewController *setting = [SettingInfoViewController new];
    
    //    [self.navigationController pushViewController:setting animated:NO];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    //
    //    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    // 模态切换的返回
    //    [self dismissViewControllerAnimated:YES completion:^{
    //        NSLog(@"这里是返回设置界面");
    //    }];
    
    
}
/**
 *  bar上面的右键
 */
- (void)rightBtnClick: (id)sender
{
    
}


/**
 *  视图即将出现时，添加bar
 */

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [super viewWillAppear:animated];
}

#pragma mark - 代理账号填写的文本框
/**
 *  当文本框失去焦点的时候，就到数据库中找对应的头像名
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSDictionary *dic = [self searchDataFromDbByString:textField.text];
    
    if (dic[@"ID"] == nil) {
        NSLog(@"输入用户不存在");
        
        self.head.image = [UIImage imageNamed:@"right_drawer_head_unlogin_press"];
        [self showTipMessage:@"用户不存在"];
        
        return;
    }
    
    self.head.image = [UIImage imageNamed:dic[@"photo"]];
    
    
    NSLog(@"查找的结果为：%@",dic);
}

@end
