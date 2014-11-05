//
//  NumCompareViewController.m
//  weather
//
//  Created by YiTong.Zhang on 14/11/3.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//  验证码校对

#import "NumCompareViewController.h"
#import "SentMail.h"
#import "ReSetPasswdViewController.h"

@interface NumCompareViewController () <SKPSMTPMessageDelegate>
{
    UITextField *numfield;
    
    // 倒计时按钮
    UIButton *reSentBtn;
    
    // 计时器
    NSTimer *timer ;
}
@end

@implementation NumCompareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    if ([UIDevice currentDevice].systemVersion.intValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }

    /**
     *  添加界面：一个输入邮箱的 文本框 和 提交按钮
     */
    
    CGFloat x = 10;
    CGFloat y = 30;
    
    CGFloat w = self.view.frame.size.width - ( x * 2 );
    
    CGFloat h = 40;
    
    // 输入文本
    numfield = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
    
    numfield.placeholder = @"请输入接收到的验证码";
    
    numfield.clearsOnBeginEditing = YES;
    
    numfield.layer.borderWidth = 1;
    
    [self.view addSubview:numfield];
    
    // 重新发送
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(x, y+h, w/2 - 15, h)];
    lab.text = @"重新发送：";
    
    [self.view addSubview:lab];
    
    // 按钮
    reSentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    reSentBtn.frame = CGRectMake(x + (w/2), y+h + 15, w/2, h );
    
    [reSentBtn setTitle:@"60 秒后重新发送" forState:UIControlStateNormal];
    
    [reSentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [reSentBtn setBackgroundColor:[UIColor blueColor]];
    
    // 绑定点击事件
    [reSentBtn addTarget:self action:@selector(reSentNumToMail:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:reSentBtn];
    
    // 提交按钮
    UIButton *sumBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, (y + h + 5) * 2, w, h)];
    
    [sumBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    [sumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [sumBtn setBackgroundColor:[UIColor grayColor]];
    
    // 绑定点击事件
    [sumBtn addTarget:self action:@selector(compareNum:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sumBtn];
    
    // 重发按钮的计时
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTime:) userInfo:nil repeats:YES];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 *  验证输入的验证码
 *
 */
- (void)compareNum: (UIButton *)aBtn
{
    if ([self.randomNum isEqualToString:numfield.text] == YES) {
        
        NSLog(@"输入的验证码正确");
        
        // 跳转到下一个设置密码的界面
        ReSetPasswdViewController *resetPasswd = [ReSetPasswdViewController new];
        
        resetPasswd.title = @"新密码";
        
        resetPasswd.mail = self.mail;
        
        [self.navigationController pushViewController:resetPasswd animated:YES];
        
    }
    else
    {
        NSLog(@"验证码输入错误");
        
        // 提示振动
        [self animateShake:numfield];
        
        // 提示信息
        [self showTipMessage:@"验证码输入错误"];
        
        
    }
}

/**
 *  计时
 *
 */
- (void)changeTime: (NSTimer *) aTimer
{
    static int i = 59;
    
    NSString *t = [NSString stringWithFormat:@"%d 秒后重新发送",i];
    
    [reSentBtn setTitle:t forState:UIControlStateNormal];
    
    if (i == 0) {
        // 停止计时器
        [timer invalidate];
        
        
        [reSentBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        
        return;
    }
    
    i--;
    
}
/**
 *  点击了重新发送验证码的按钮所触发的事件
 *
 */
- (void)reSentNumToMail:(UIButton *)aBtn
{
    // 重新生成验证码
    // 1、发送验证码  4位
    
    NSString *titleText = [NSString stringWithCString:"天气账号管理" encoding:NSUTF8StringEncoding];
    
//    NSString *mail = emailField.text;
    
    // 4位数随机码
    int randomNum = (arc4random() % 9000) + 1000;
    NSString *randomCode = [NSString stringWithFormat:@"%d",randomNum];
    
    NSString *content = [NSString stringWithFormat:@"验证码是：%@",randomCode];
    
    SKPSMTPMessage *sendMail = [SentMail sentMailWithTitle:titleText toMail:self.mail withContent:content ];
    
    sendMail.delegate = self;
    
    [sendMail send];
    
    // 重设校对验证码
    self.randomNum = randomCode;
    
    
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
