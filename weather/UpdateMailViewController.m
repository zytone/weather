//
//  UpdateMailViewController.m
//  weatherSet
//
//  Created by ibokan on 14-10-30.
//  Copyright (c) 2014年 chan. All rights reserved.
//

#import "UpdateMailViewController.h"

@implementation UpdateMailViewController


-(void)loadView
{
    
    
    
    [super loadView];
    self.view.userInteractionEnabled = YES;
#pragma mark -Rect
    
    CGRect RusernameLabel = CGRectMake(22, 150, 320, 44);
    CGRect Rverification = CGRectMake(22, 200, 320-200, 44);

    CGRect RAlter = CGRectMake(44, 450, 320-88, 44);
    
    CGRect RSend = CGRectMake(180, 200, 320-180, 44);
    
    
#pragma mark -测试用的plist暂时写入
    
    NSUserDefaults *defaultsss = [NSUserDefaults standardUserDefaults];
    
    [defaultsss setObject:@"1030235115@qq.com" forKey:@"username"];//测试用
    
    [defaultsss synchronize];//立即写入数据到plist文件中//测试用
    
    
    
    
    
#pragma mark -主屏幕点击消键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitEditing:)];
    [self.view addGestureRecognizer:tap];
    
    
#pragma mark -显示当前邮箱
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mail = [NSString stringWithFormat:@"绑定邮箱 : %@",[defaults stringForKey:@"username"]];
    _userName = [[UILabel alloc]initWithFrame:RusernameLabel];
    
   _userName.text = mail;
    [self.view addSubview:_userName];
    
    
    
    _verification = [[UITextField alloc]initWithFrame:Rverification];

    
    _verification.delegate = self;

    
    
    
    //水印提示
    
    NSDictionary *waterMarkDic  = @{NSForegroundColorAttributeName: [UIColor grayColor]};
    _verification.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入验证码" attributes:waterMarkDic];

    
    
    //不执行纠错
    
    _verification.autocorrectionType = UITextAutocorrectionTypeNo;
    
    //一键清空
    _verification.clearButtonMode =UITextFieldViewModeAlways;
  
    
    
    //再次编辑，自动清空
    _verification.clearsOnBeginEditing = YES;

    
    
    //
    _verification.layer.masksToBounds = YES;

    
    
    //边框颜色
    _verification.layer.borderColor = [[UIColor blackColor]CGColor];

    
    _verification.layer.borderWidth = 1.0f;
   
    
    
#pragma mark -获取验证码按钮
    
    _send = [[UIButton alloc]initWithFrame:RSend];
    
    [_send setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    
    [_send setBackgroundColor: [UIColor orangeColor]];
    
    [self.view addSubview:_send];
    
    
    [_send addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    
    
#pragma mark -确认修改按钮
    _AlterBtn = [[UIButton alloc]initWithFrame:RAlter];
    
    [_AlterBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    
    [_AlterBtn addTarget:self action:@selector(Alter:) forControlEvents:UIControlEventTouchUpInside];
    
    [_AlterBtn setBackgroundColor:[UIColor blueColor]];
    
    
    
    
    
    

    [self.view addSubview:_verification];
    
    
    [self.view addSubview:_AlterBtn];
    
    
    
    
    
    
    
    
    
    

    
    
}

#pragma mark -发送验证码
-(void)send:(id)sender
{
    
    SKPSMTPMessage *testSend = [[SKPSMTPMessage alloc]init];
    testSend.fromEmail = @"weathertt@163.com"; // 发出邮件的邮箱
    //    testSend.toEmail = _userName.text;  // 接受邮件的邮箱地址
#warning 这里用的是默认的邮箱
    testSend.toEmail = @"526964661@qq.com";
    testSend.relayHost = @"smtp.163.com"; // 163邮箱的服务器地址
    testSend.requiresAuth = YES;
    testSend.login = @"weathertt@163.com";  //发出邮件的邮箱账号
    testSend.pass = @"a123456";  // 发出邮件的邮箱密码
    testSend.subject = [NSString stringWithCString:"天气账号密码找回验证码" encoding:NSUTF8StringEncoding]; // 邮件的标题
    testSend.wantsSecure = YES;
    testSend.delegate = self;
    
    // 4位数随机码
    int randomNum = (arc4random() % 9000) + 1000;
    _randomCode = [NSString stringWithFormat:@"%d",randomNum];
    NSString *randomDesc = [NSString stringWithFormat:@"验证码是：%@",_randomCode];
    
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                               randomDesc,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    testSend.parts = [NSArray arrayWithObjects:plainPart, nil];
    
    [testSend send];
//    NSLog(@"fdasf");
}
#pragma mark -Alter
-(void)Alter:(id)sender
{
    
}
#pragma mark -邮件发送成功的代理方法
- (void)messageSent:(SKPSMTPMessage *)message
{
    NSLog(@"发送成功!!!");
    
}

#pragma mark -邮件发送失败的代理方法
- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    NSLog(@"发送失败,错误：%@",error);
}

#pragma mark  -设置了代理，解决最后一个文本框被键盘遮挡的问题
-(void)textFieldDidBeginEditing:(UITextField *)textField//开始编辑输入框时执行
{
    
    
    CGRect frame = _verification .frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 231);//键盘高度216,用了231
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
    
    
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
    
    

    
}


-(void)exitEditing:(UITapGestureRecognizer *)aTap
{
    
    [self.view endEditing:YES];
}



@end
