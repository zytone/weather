//
//  RetrievePasswdByEmailViewController.m
//  weather
//
//  Created by YiTong.Zhang on 14/11/3.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//  找回密码的第一个页面

/**
 
 1、验证在数据库中是否存在了数据
 2、发送验证码，验证码为4位
 3、跳到下一个输入验证码页面
 4、正确输入验证码之后，跳到设置新密码的页面
 5、找回成功
 
 */

#import "RetrievePasswdByEmailViewController.h"
#import "User.h"

@interface RetrievePasswdByEmailViewController ()
{
    UITextField *emailField;
}
@end

@implementation RetrievePasswdByEmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView
{
    [super loadView];
    
    /**
     *  添加界面：一个输入邮箱的 文本框 和 提交按钮
     */
    
    CGFloat x = 10;
    CGFloat y = 30;
    
    CGFloat w = self.view.frame.size.width - ( x * 2 );
    
    CGFloat h = 60;
    
    // 输入文本
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
    
    emailField.placeholder = @"请输入注册的邮箱账号";
    
    emailField.clearsOnBeginEditing = YES;
    
    emailField.layer.borderWidth = 1;
    
    [self.view addSubview:emailField];
    
    // 提交按钮
    UIButton *sumBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y + h, w, h)];
    
    [sumBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [sumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [sumBtn setBackgroundColor:[UIColor grayColor]];
    
    // 绑定点击事件
    [sumBtn addTarget:self action:@selector(submitEmail:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sumBtn];
    
    
    
    
}

/**
 *  提交按钮点击后的事件
 *
 */
- (void)submitEmail:(UIButton *)aBtn
{
    // 验证数据库是否存在该邮箱的记录
    // 存在该条数据
    if ([self confirmationBySqliteWithEmail:emailField.text] == YES) {
        // 1、发送验证码  4位
        
        // 2、跳转页面
        
        
    }
    else
    {
        // 振动文本框
        [self animateShake:emailField];
        
        // 提示错误
        [self showTipMessage:@"该邮箱未注册"];
    }
    
}

/**
 *  验证数据库是否存在该邮箱
 *
 */
- (BOOL) confirmationBySqliteWithEmail :(NSString *)aEmail
{
    BOOL b = NO;
    
    NSInteger i = [User getCountByUsername:aEmail];
    
    if (i == 1) {
        
        NSLog(@"这里是找回密码的验证,查找到的数量为: %d",i);
        return YES;
        
    }
    
    return b;
}


/**
 *  视图即将出现的时候，修改nav bar的东西
 *
 *  @param animated
 */
- (void)viewWillAppear:(BOOL)animated
{
    
}


#pragma mark -错误震动动画
- (void)animateShake:(UIView *)sender
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





@end
