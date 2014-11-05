//
//  RegisterViewController.m
//  weatherRegister
//
//  Created by chan on 14-10-22.
//  Copyright (c) 2014年 chan. All rights reserved.
//

#import "RegisterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"
@interface RegisterViewController ()


@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    
    [super loadView];
    
//    // 针对ios7的适配
//    if ([UIDevice currentDevice].systemVersion.intValue >= 7) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }

    self.navigationController.navigationBarHidden = NO;
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
//    self.navigationController.navigationBar.alpha = 0.5;
    
    UIImageView *bgImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"112.jpg"]];
    
    self.view = bgImg;
    
    self.view.userInteractionEnabled = YES;
    
    
    
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitEditing:)];
    [self.view addGestureRecognizer:tap];
    
    
#pragma mark -文本框的设定
    
    // _username = [[UITextField alloc]initWithFrame:CGRectMake(44, 284-200, 320-88, 44)];
    // _uPassword = [[UIView alloc]initWithFrame:CGRectMake(44, 350-200, 320-88, 44)];
    //位置
    _username = [[UITextField alloc]initWithFrame:CGRectMake(-320, 284-200, 320-88, 44)];
    
    _uPassword = [[UIView alloc]initWithFrame:CGRectMake(320, 350-200, 320-88, 44)];
    
    _password = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 320-88-44, 44)];

    
    
    /*
     //昵称
     _name = [[UITextField alloc]initWithFrame:CGRectMake(44, 360, 320-88, 44)];
     _name.delegate = self;
     [RegisterViewController borderColor:_name];
     _name.clearButtonMode = UITextFieldViewModeAlways;
     _name.autocorrectionType = UITextAutocorrectionTypeNo;
     _name.placeholder = @"请输入昵称";
     [self.view addSubview:_name];
     */
    
    _username.delegate = self;
    _password.delegate = self;
    
    
    //文本框配色
    
//    [RegisterViewController borderColor:_username];
//    [RegisterViewController borderColor:_password];

    
    _username.layer.borderColor = [[UIColor clearColor] CGColor];
    _password.layer.borderColor = [[UIColor clearColor] CGColor];
    
    
    //下划线
    UILabel *t1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 299-200, 320, 44)];
    
    UILabel *t2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 365-200, 320, 44)];
    
    t1.text = @"_________________________________";
    t2.text = @"_________________________________";
    
    t1.textColor = [UIColor grayColor];
    t2.textColor = [UIColor grayColor];
    
    [self.view addSubview:t1];
    [self.view addSubview:t2];
    
    
    
    //X号，一次性删除textfield里的内容
    _username.clearButtonMode = UITextFieldViewModeAlways;
    _password.clearButtonMode = UITextFieldViewModeAlways;
    
    //密码栏再次编辑，清空
    
    _password.clearsOnBeginEditing = YES;
    
    
    //不执行纠错
    _username.autocorrectionType = UITextAutocorrectionTypeNo;
    _password.autocorrectionType = UITextAutocorrectionTypeNo;
    
    
    
    //水印提示
    _username.placeholder = @"请输入正确的注册邮箱";
    _password.placeholder = @"请输入密码";
    
    
    //左侧图标
    
    _usernameLIV1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_user_os7@2x.png"] ];
    _usernameLIV2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_user_highlighted_os7@2x.png"] ];
    
    _passwordLIV1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_key_os7@2x.png"]];
    
    _passwordLIV2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_key_highlighted_os7@2x.png"]];
    
    //leftView图片大小
    CGFloat leftViewHeight = 30;
    CGFloat leftViewWidth = 30;
    
    _usernameLIV1.frame = CGRectMake(0, 0, leftViewWidth, leftViewHeight);
    _usernameLIV2.frame = CGRectMake(0, 0, leftViewWidth, leftViewHeight);
    _passwordLIV1.frame = CGRectMake(0, 0, leftViewWidth, leftViewHeight);
    _passwordLIV2.frame = CGRectMake(0, 0, leftViewWidth, leftViewHeight);
    
    _username.leftView = _usernameLIV1;
    _password.leftView = _passwordLIV1;
    
    
    _username.leftViewMode =  UITextFieldViewModeUnlessEditing;  //没有编辑的时候
    _password.leftViewMode = UITextFieldViewModeUnlessEditing;
    
    
    
#pragma mark -动画
    
    [UIView animateKeyframesWithDuration:1.0 delay:0 options:0 animations:^(){
    
        CGRect tmp = _username.frame;
        tmp.origin.x = 44;
        
        _username.frame = tmp;
        
        tmp = _uPassword.frame;
        tmp.origin.x = 44;
        
        _uPassword.frame = tmp;
        
    
    
    } completion:nil];
                    
    
    
#pragma mark - 文本
    /*
     _lusername = [[UILabel alloc]initWithFrame:CGRectMake(44, 150-44, 150, 44)];
     _lpassword = [[UILabel alloc]initWithFrame:CGRectMake(44,250-44, 150, 44)];
     _lname = [[UILabel alloc]initWithFrame:CGRectMake(44, 360-44, 150, 44)];
     
     
     
     
     _ltpassword = [[UILabel alloc]initWithFrame:CGRectMake(44, 250+45, 250, 20)];
     //    _ltname = [[UILabel alloc]initWithFrame:CGRectMake(44, 350+45, 150, 20)];
     
     
     
     _lusername.text = @"登录名 : ";
     _lpassword.text = @"设置密码 : ";
     _lname.text = @"昵称 : ";
     
     _lusername.font =[UIFont fontWithName:@"Helvetica" size:20 ];
     _lpassword.font =[UIFont fontWithName:@"Helvetica" size:20 ];
     _lname.font =[UIFont fontWithName:@"Helvetica" size:20 ];
     
     
     //Label Tips输入提示
     _ltpassword.text = @"密码在6~16位之间，为数字或字母";
     //    _ltname.text = @"昵称在4~8位之间";
     _ltpassword.textColor = [UIColor redColor];
     //    _ltname.textColor = [UIColor redColor];
     
     _ltpassword.font = [UIFont fontWithName:@"Helvetica" size:12 ];
     //    _ltname.font = [UIFont fontWithName:@"Helvetica" size:12 ];
     //
     
     int k = 150-44;
     for (int i=0; i<=1; i++) {
     _mark = [[UILabel alloc] initWithFrame:CGRectMake(30, k+5, 10, 44)];
     _mark.text = @"*";
     _mark.font =  [UIFont fontWithName:@"Helvetica" size:30 ];
     _mark.textColor = [UIColor redColor];
     [self.view addSubview:_mark];
     k+=100;
     }
     
     
     _low = [[UILabel alloc]initWithFrame:CGRectMake(80, 568-40, 250, 20)];
     _low.text = @"已阅读并同意天气网络协议";
     _low.font = [UIFont fontWithName:@"Helvetica" size:14 ];
     
     
     
     [self.view addSubview:_lusername];
     
     [self.view addSubview:_lpassword];
     [self.view addSubview:_lname];
     
     [self.view addSubview:_ltpassword];
     //    [self.view addSubview:_ltname];
     
     [self.view addSubview:_low];
     */
    
    
    
#pragma mark -按钮
    
    //注册按钮
    _regist = [[UIButton alloc]initWithFrame:CGRectMake(20, 568-120-200, 320-40, 55)];
    _myColorBlue = [[UIColor alloc]initWithRed:0.3 green:0.5 blue:0.8 alpha:0.8];
    _regist.backgroundColor = _myColorBlue;
  
    
    //    _regist.layer.cornerRadius=6.0f;
    [_regist setTitle:@"立即注册" forState:UIControlStateNormal];
    
    
    
    //密码隐藏按钮
    _uPassword.userInteractionEnabled = YES;
    //    _secure = [[UIButton alloc]initWithFrame:CGRectMake(320-88, 250,44, 44)];
    _secure = [[UIButton alloc]initWithFrame:CGRectMake(320-88-44, 0,44, 44)];
//    _secure.backgroundColor = _myColorBlue;
    //    _secure.layer.cornerRadius = 6.0f;
    passwordSecure = NO;//密码栏初始设为隐藏
    [_secure setTitle:@"ABC" forState:UIControlStateNormal];
    [_secure setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    
    [self.view addSubview:_uPassword];
    
    [self.view addSubview:_username];
    [_uPassword addSubview:_password];
    
    [self.view addSubview:_regist];
    [_uPassword addSubview:_secure];
    
    
    
    [_regist addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [_secure addTarget:self action:@selector(secure:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
#pragma mark  -设置了代理，解决最后一个文本框被键盘遮挡的问题
-(void)textFieldDidBeginEditing:(UITextField *)textField//开始编辑输入框时执行
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 231.0);//键盘高度216,用了231
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
    
    //编辑的时候，leftView高亮
    
    if (textField == _username) {
        textField.leftView = _usernameLIV2;
    }
    if (textField == _password) {
        textField.leftView = _passwordLIV2;
    }
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField//return键返回
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField//结束后，还原位置
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    
    //取消leftView高亮状态
    
    if (textField == _username) {
        textField.leftView = _usernameLIV1;
    }
    if (textField == _password) {
        textField.leftView = _passwordLIV1;
    }
    
    
}
#pragma mark - 文本框配色
+(void)borderColor:(UITextField *)sender
{
    
    UIColor *colorBlue = [[UIColor alloc]initWithRed:0.3 green:0.5 blue:0.8 alpha:0.8];
    //    sender.layer.cornerRadius=8.0f;
    sender.layer.masksToBounds=YES;
    sender.layer.borderColor=[colorBlue CGColor];
    sender.layer.borderWidth= 1.0f;
}
#pragma mark -错误震动动画
+(void)animateShake:(UIView *)sender
{
    CGPoint c ;
    CGPoint l ;
    CGPoint r ;
    int ra = arc4random()%2;
    if (ra == 0) {
        c = sender.center;
        l = CGPointMake(c.x-10, c.y);
        r = CGPointMake(c.x+10, c.y);
    }
    else if (ra == 1) {
        c = sender.center;
        l = CGPointMake(c.x+10, c.y);
        r = CGPointMake(c.x-10, c.y);
    }
    
    
    CAKeyframeAnimation  *ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    ani.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:l],[NSValue valueWithCGPoint:c],[NSValue valueWithCGPoint:r],[NSValue valueWithCGPoint:c],[NSValue valueWithCGPoint:l],[NSValue valueWithCGPoint:c], nil];
    
    [sender.layer addAnimation:ani forKey:@"ani-1"];
    
}
#pragma mark -键盘退出
-(void)exitEditing:(UITapGestureRecognizer *)aTap
{
    
    [self.view endEditing:YES];
}
#pragma mark -密码隐藏/显示
-(void)secure:(id)sender
{
    if (passwordSecure == YES) {
        _password.secureTextEntry = NO;
        passwordSecure = NO;
        [_secure setTitle:@"ABC" forState:UIControlStateNormal];
        _secure.titleLabel.font = [UIFont systemFontOfSize: 18.0];//还原字体大小
        _secure.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        
        
    }
    else if(passwordSecure == NO)
    {
        _password.secureTextEntry = YES;
        passwordSecure = YES;
        [_secure setTitle:@"***" forState:UIControlStateNormal];
        _secure.titleLabel.font = [UIFont systemFontOfSize:30.0];
        _secure.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
    }
}
#pragma mark -注册按钮发生的事件
-(void)regist:(id)sender
{
    //用户名验证
    usernameResult =  [RegisterViewController validateEmail:_username.text];
    if (usernameResult == NO) {
        
        [RegisterViewController animateShake:_username];//错误震动效果
        
    }
    else if (usernameResult == YES)
    {
        NSLog(@"邮箱格式正确");
        
        
    }
    //密码验证
    passwordResult = [RegisterViewController validatePassword:_password.text];
    if (passwordResult == NO) {
        NSLog(@"密码格式错误");
        [RegisterViewController animateShake:_uPassword];//错误震动效果
        
    }
    else if(passwordResult == YES)
    {
        NSLog(@"密码格式正确");
    }
    
    
#pragma mark -信息录入
    if (usernameResult == YES && passwordResult == YES) {
        
        //录入 _username _password _name的text
        User *user  =[[User alloc] init];
        
        user.username = _username.text;
        user.passwd = _password.text;
        //        user.name = _name.text;
        [LRWDBHelper addDataToTable:@"User" example:user];
        NSLog(@"%@",[LRWDBHelper findDataFromTable:@"User" byExample:nil]);
    }
    
    
}

#pragma mark -注册的正则判定
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[A-Za-z0-9]{6,16}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    BOOL C =  [passWordPredicate evaluateWithObject:passWord];
    return C;
}

+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
   
    

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
