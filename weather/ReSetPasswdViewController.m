//
//  ReSetPasswdViewController.m
//  weather
//
//  Created by YiTong.Zhang on 14/11/5.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import "ReSetPasswdViewController.h"
#import "User.h"
#import "LRWDBHelper.h"
#import "LoginViewController.h"

@interface ReSetPasswdViewController ()
{
    UITextField *passwField;
    
    // 修改密码按钮
    UIButton *reSentBtn;
    
}

@end

@implementation ReSetPasswdViewController

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
    
    if ([UIDevice currentDevice].systemVersion.intValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    
    /**
     *  添加界面：一个输入邮箱的 文本框 和 提交按钮
     */
    
    CGFloat x = 10;
    CGFloat y = 30;
    
    CGFloat w = self.view.frame.size.width - ( x * 2 );
    
    CGFloat h = 30;
    
    // 输入文本
    passwField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
    
    passwField.placeholder = @"请输入新的密码";
    
    passwField.clearsOnBeginEditing = YES;
    
    passwField.layer.borderWidth = 1;
    
    [self.view addSubview:passwField];
    
    // 提交按钮
    UIButton *sumBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, (y + h) * 2, w, h)];
    
    [sumBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    
    [sumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [sumBtn setBackgroundColor:[UIColor grayColor]];
    
    // 绑定点击事件
    [sumBtn addTarget:self action:@selector(compareNum:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sumBtn];
    
}

-(void)compareNum:(UIButton *)aBtn
{
    NSLog(@"保存新密码");
    
    aBtn.userInteractionEnabled = NO;
    
    User *userInfo = [[User alloc] init];
    
    userInfo.userName = self.mail;
    
    NSArray *arr = [LRWDBHelper findDataFromTable:@"user" byExample:userInfo];
    
    NSDictionary *dicUser = [arr lastObject];
    
    NSLog(@"userinfo : %@",[userInfo valueForKey:@"passwd"]);
    
//    [userInfo setPasswd:passwField.text];
    [userInfo setValue:passwField.text forKey:@"passwd"];
    
    User *update = [User new];
    
    [update setValuesForKeysWithDictionary:dicUser];
    
//    update.ID = (int)[userInfo valueForKey:@"ID"];
//    update.name = [userInfo valueForKey:@"name"];
//    update.userName = [userInfo valueForKey:@"username"];
    update.passwd = passwField.text;
//    update.phoneNum = [userInfo valueForKey:@"phoneNum"];
//    update.photo = [userInfo valueForKey:@"photo"];
    
    
    
    
//    //通过finddata方法，返回一个条件查询后返回的数组，由于账号密码对应的只有一个，将最后的数据转换为字典
//    NSDictionary *dic = [[LRWDBHelper findDataFromTable:@"user" byExample:_alterUser] lastObject];
//    
//    //根据字典的key，转回一个对象
//    [_alterUser setValuesForKeysWithDictionary:dic];
//    
//    //跟新
//    _alterUser.passwd = _NewPassword.text;
//    [LRWDBHelper updateOneDataFromTable:@"user" example:_alterUser];
    

    NSLog(@"update:%@",update.passwd);
    
    BOOL b = [LRWDBHelper updateOneDataFromTable:@"user" example:update];
    
    if (b == YES) {
        // 显示成功
        [self showTipMessage:@"修改成功！~"];
        // 跳转
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            LoginViewController *login = [LoginViewController new];
            
            [self.navigationController pushViewController:login animated:YES];
        });
    }
    else
    {
        // 显示失败
    }
    
    
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







@end
