//
//  SettingInfoViewController.m
//  PushChat
//
//  Created by YiTong.Zhang on 14/10/30.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import "SettingInfoViewController.h"

// 跳转时需要的头文件
#import "../LoginViewController.h"
#import "../AlertsViewController.h"
#import "RootNavigationController.h"
#import "SetViewController.h"

// 视图头文件
#import "SettingInfoTableViewCell.h"
#import "SettingHeadTableViewCell.h"
#import "SettingTableView.h"



#define VIEW_WIDTH self.view.frame.size.width
#define VIEW_HEIGHT self.view.frame.size.height
#define VIEW_X self.view.frame.origin.x
#define VIEW_Y self.view.frame.origin.y

@interface SettingInfoViewController () <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,SettingTableDelegate>
{
    SettingTableView *settingTableView;
    
    // 存放每一个行的主要内容
    NSArray *mArr;
    
    // 存放用户信息
    NSDictionary *_dic;
}
@end

@implementation SettingInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //  initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // 针对ios7的适配
    if ([UIDevice currentDevice].systemVersion.intValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    
}

- (void)loadView
{
    [super loadView];
    
//    self.navigationController.navigationBar.hidden = YES;
    
    NSArray *arr = @[@"拍照",@"提醒",@"生活指数"];
    
    mArr = arr;
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    _dic = [user objectForKey:@"userInfo"];
    
    
    settingTableView = [[SettingTableView alloc] init];
    settingTableView.delegate = self;
    
    [self.view addSubview:settingTableView];
    
}



- (void)settingTableCellDidClickWithIndex:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self userInfo];
                break;
                
            case 2:
                [self pushToNotificationVC];
                break;
                
            default:
                break;
        }
    }
}
/**
 *  点击用户图标
 登录后：个人设置
 未登录：登录界面
 */
-(void) userInfo
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [user objectForKey:@"userInfo"];
    
    if (dic!= nil) {
        SetViewController *setView = [SetViewController new];
        [self.navigationController pushViewController:setView animated:YES];
        return;
    }
    
//    NSLog(@"%@",dic);
    
    [self pushToLogin];
}

#pragma mark - nav切换页面
/**
 *  跳转到天气通知设置
 */
- (void) pushToNotificationVC
{
    AlertsViewController *notification = [AlertsViewController new];
    
    [self.navigationController pushViewController:notification animated:YES];
    
}

/**
 *  跳转到生活指数界面
 */
- (void) pushToLifeAdviceVC
{
    
}

/**
 *  跳转到登录界面
 */
- (void) pushToLogin
{
    // 用模态切换页面
    LoginViewController *login = [LoginViewController new];

    // 跳转的效果
//    login.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    
//    // 跳转到login页面
//    [self presentViewController:login animated:YES completion:^{
//        
//    }];
    
    // 用nav切换页面
    [self.navigationController pushViewController:login animated:YES];
}
/**
 *  设置个人登录后的信息
 */
- (void) pushToPersonInfo
{
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [super viewWillAppear:animated];
}

- (void) userChange : (id)sender
{
    
    [[settingTableView.subviews lastObject] reloadData];
    
    NSArray *mSet = settingTableView.subviews;
    
    NSLog(@"执行了这里，reloadData  %d",mSet.count  );

}

@end
