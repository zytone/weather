//
//  LoginViewController.m
//  weather
//
//  Created by YiTong.Zhang on 14-10-22.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import "LoginViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <QuartzCore/QuartzCore.h>
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "settingInfo/SettingInfoViewController.h"


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
@interface LoginViewController ()<TencentSessionDelegate,UINavigationControllerDelegate>
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
    
    
    // 设置View的背景
    self.view.backgroundColor = [UIColor colorWithRed:244/254.0 green:244/254.0 blue:244/254.0 alpha:1];
    
    //  ------  页面切换
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    
    self.navigationController.delegate = self;
    
    // 下面2种都可以去掉系统的下划线
//    self.navigationController.navigationBar.clipsToBounds = YES;
//    [self.navigationController.navigationBar.layer setMasksToBounds:YES];
    
    [self setNavBar];
    
//    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 70, 30)];
//    
//    [backBtn setTitle:@"返回" forState:UIControlStateNormal]  ;
//    [backBtn.titleLabel setFont:[UIFont fontWithName:nil size:15]];
//    [backBtn setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
//    [backBtn setTitleColor: [UIColor grayColor] forState:UIControlStateHighlighted];
//    
//    [backBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backBtn];
    
    //  ------  页面切换 end -------------
    
    // 1、头像
    UIImage *headImage = [UIImage imageNamed:@"head"];
    
    CGFloat headW = headImage.size.width;
    CGFloat headH = headImage.size.height;
    CGFloat headX = (self.view.frame.size.width - headW)*0.5;
    CGFloat headY = 66;
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(headX, headY, headW, headH)];
    headView.image = headImage;
    headView.layer.masksToBounds = YES;
    headView.layer.cornerRadius = headImage.size.width*0.5;
    self.head = headView;
    [self.view addSubview:headView];
    
    // 2、账号
    CGFloat padding = PADDING;//左右边距
    CGFloat userW = self.view.frame.size.width - padding *2;
    CGFloat userH = TEXTFILEDHEIGHT;
    CGFloat userX = PADDING;
    CGFloat userY = CGRectGetMaxY(headView.frame) + DISTANCE;
    UITextField *userFiled = [[UITextField alloc] initWithFrame:CGRectMake(userX, userY, userW, userH)];
    userFiled.backgroundColor = [UIColor whiteColor];
    userFiled.layer.cornerRadius = 5;
    userFiled.placeholder = @"请输入你的邮箱";
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, userH)];
    userLabel.text = @" 帐号：";
    userFiled.leftView = userLabel;
    userFiled.leftViewMode = UITextFieldViewModeAlways;
    userFiled.clearButtonMode = UITextFieldViewModeAlways;
    self.userFiled = userFiled;
    [self.view addSubview:userFiled];
    
    // 3、密码
    CGFloat passwFiledW = self.view.frame.size.width - padding *2;
    CGFloat passwFiledH = TEXTFILEDHEIGHT;
    CGFloat passwFiledX = PADDING;
    CGFloat passwFiledY = CGRectGetMaxY(userFiled.frame) + TEXTPADDING;
    UITextField *passwFiled = [[UITextField alloc] initWithFrame:CGRectMake(passwFiledX, passwFiledY, passwFiledW, passwFiledH)];
    passwFiled.backgroundColor = [UIColor whiteColor];
    passwFiled.layer.cornerRadius = 5;
    passwFiled.placeholder = @"请输入你的密码";
    
    UILabel *passwLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, userH)];
    passwLabel.text = @" 密码：";
    passwFiled.leftView = passwLabel;
    passwFiled.leftViewMode = UITextFieldViewModeAlways;
    
    passwFiled.secureTextEntry = YES;
    
    passwFiled.clearButtonMode = UITextFieldViewModeAlways;
    
    self.userFiled = passwFiled;
    [self.view addSubview:passwFiled];
    
    // 4、登陆按钮
    CGFloat loginW = userW;
    CGFloat loginH = userH;
    CGFloat loginX = PADDING;
    CGFloat loginY = CGRectGetMaxY(passwFiled.frame) +DISTANCE;
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(loginX, loginY, loginW, loginH)];
    loginBtn.backgroundColor = [UIColor colorWithRed:0.3 green:0.5 blue:0.8 alpha:0.8];
    
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    
//    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    loginBtn.userInteractionEnabled = YES;
    
//    loginBtn.showsTouchWhenHighlighted = YES;
    loginBtn.enabled = NO;
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    
    //第三方登陆
    CGFloat tipW = self.view.frame.size.width*0.5;
    CGFloat tipH = 40;
    CGFloat tipX = PADDING;
    CGFloat tipY = CGRectGetMaxY(loginBtn.frame) +PADDING;
    UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(tipX, tipY, tipW, tipH)];
    tipLable.text = @"其他登陆：";
    [tipLable setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:tipLable];
    
    
    
    UIImage *WBImg = [UIImage imageNamed:@"sinaLogo"];
    CGFloat WBW = WBImg.size.width;
    CGFloat WBH = WBImg.size.height;
    CGFloat WBX = 100;
    CGFloat WBY = CGRectGetMaxY(tipLable.frame);
    UIButton *WBBtn = [[UIButton alloc] initWithFrame:CGRectMake(WBX, WBY, WBW, WBH)];
    [WBBtn setImage:WBImg forState:UIControlStateNormal];
    [WBBtn addTarget:self action:@selector(wbLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:WBBtn];
    self.WBLogin = WBBtn;
    
    UIImage *QQImg = [UIImage imageNamed:@"qqLogin"];
    CGFloat QQW = QQImg.size.width;
    CGFloat QQH = QQImg.size.height;
    CGFloat QQX = CGRectGetMaxX(WBBtn.frame) + DISTANCE;
    CGFloat QQY = WBY;
    UIButton *QQBtn = [[UIButton alloc] initWithFrame:CGRectMake(QQX, QQY, QQW, QQH)];
    [QQBtn setImage:QQImg forState:UIControlStateNormal];
    [QQBtn addTarget:self action:@selector(qqLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:QQBtn];
    self.QQLogin = QQBtn;
    
    // 注册  忘记密码
    CGFloat containerW = self.view.frame.size.width * 0.5;
    CGFloat containerH = 30;
    CGFloat containerX = containerW*0.5;
    CGFloat containerY = self.view.frame.size.height - containerH;
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(containerX, containerY, containerW, containerH)];
    [self.view addSubview:container];
    
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, containerW*0.5, containerH)];
    [registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [registerBtn setTitleColor:[UIColor colorWithRed:166 green:203 blue:254 alpha:1] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [container addSubview:registerBtn];
    self.registerBtn = registerBtn;
    
    UIButton *forgetBtn = [[UIButton alloc] initWithFrame:CGRectMake(containerW*0.5, 0, containerW*0.5, containerH)];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [forgetBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [forgetBtn setTitleColor:[UIColor colorWithRed:166 green:203 blue:254 alpha:1] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:forgetBtn];
    self.forgetBtn = forgetBtn;
    //分割线
    UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(containerW*0.5, containerH*0.2,1, containerH *0.6)];
    separateLine.backgroundColor =[UIColor grayColor];
    [container addSubview:separateLine];
    
    //手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
    //初始化QQ
    self.tencent = [[TencentOAuth alloc] initWithAppId:AppId andDelegate:self];
    
    //增加输入框文本长度监听
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (![self.userFiled.text isEqualToString:@""]
            && ![self.passwordFiled.text isEqualToString:@""]) {
            self.loginBtn.enabled = YES;
        }else
        {
           self.loginBtn.enabled = NO;
        }
    }];
}

#pragma mark --本页按钮点击--
//登陆点击
-(void)loginBtnClick:(UIButton *)btn
{
    
}
//忘记密码点击
-(void)forgetBtnClick:(UIButton *)btn
{
    
}
//注册点击
-(void)registerBtnClick:(UIButton *)btn
{
    [self pushToRegister];
}
/**
 *  退出键盘
 */
-(void)tapAction
{
    [self.view endEditing:YES];
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
    NSString *home = NSHomeDirectory();
    NSString *path = [home stringByAppendingPathComponent:@"qqData"];
    
    //如果文件不存在，则创建
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if (![fileManage fileExistsAtPath:path]) {
        [fileManage createFileAtPath:path contents:nil attributes:nil];
    }
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.tencent.accessToken forKey:@"accessToken"];
    [archiver encodeObject:self.tencent.openId forKey:@"openId"];
    [archiver encodeObject:self.tencent.expirationDate forKey:@"expirationDate"];
    //完成归档
    [archiver finishEncoding];
    [data writeToFile:path atomically:YES];
    
    //获取用户信息
    [self.tencent getUserInfo];
    [self showTipMessage:@"登陆成功"];
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

//获取用户信息
-(void)getUserInfoResponse:(APIResponse *)response
{
    NSLog(@"json----%@",response.jsonResponse);
    NSLog(@"nickname:%@",response.jsonResponse[@"nickname"]);
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
    tipLable.backgroundColor = [UIColor grayColor];
    tipLable.textAlignment = NSTextAlignmentCenter;
    tipLable.layer.cornerRadius = 5;
    tipLable.layer.masksToBounds = YES;
    [self.view addSubview:tipLable];
    
    
    [UIView animateWithDuration:0.8 animations:^{
        tipLable.alpha = 1;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.8 delay:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            tipLable.alpha = 0;
        } completion:^(BOOL finished) {
            [tipLable removeFromSuperview];
        }];

    }];
}


#pragma mark - nav 跳转
/**
 *  跳到注册页面
 */
- (void) pushToRegister
{
    RegisterViewController *reg = [[RegisterViewController alloc] init];
    
    [self.navigationController pushViewController:reg animated:YES];
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [super viewWillAppear:animated];
}



@end
