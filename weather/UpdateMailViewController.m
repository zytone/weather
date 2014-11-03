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
#pragma mark -Rect
    
    CGRect RusernameLabel = CGRectMake(22, 150, 320, 44);
    CGRect Rverification = CGRectMake(44, 200, 320-88, 44);

    CGRect RAlter = CGRectMake(44, 450, 320-88, 44);
    
    
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
    UILabel *username = [[UILabel alloc]initWithFrame:RusernameLabel];
    
    username.text = mail;
    [self.view addSubview:username];
    
    
    
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
   
    
    
    _AlterBtn = [[UIButton alloc]initWithFrame:RAlter];
    
    [_AlterBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    
    [_AlterBtn addTarget:self action:@selector(Alter:) forControlEvents:UIControlEventTouchUpInside];
    
    [_AlterBtn setBackgroundColor:[UIColor blueColor]];
    
    
    
    
    
    

    [self.view addSubview:_verification];
    
    
    [self.view addSubview:_AlterBtn];
    
    
    
    
    
    
    
    
    
    

    
    
}
#pragma mark -Alter
-(void)Alter:(id)sender
{
    NSLog(@"dasf");
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
