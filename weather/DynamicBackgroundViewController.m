//
//  DynamicBackgroundViewController.m
//  help
//
//  Created by chan on 14-11-5.
//  Copyright (c) 2014年 chan. All rights reserved.
//

#import "DynamicBackgroundViewController.h"

@interface DynamicBackgroundViewController ()

@end

@implementation DynamicBackgroundViewController

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
    
    UIColor *bgc = [[UIColor alloc] initWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
    
    self.view.backgroundColor = bgc;
    
    
    self.title = @"动态背景";
    
    
    UIView *white = [[UIView alloc]initWithFrame:CGRectMake(10, 80, 300, 568-90)];
    
    white.backgroundColor = [UIColor whiteColor];
    
    white.layer.masksToBounds = YES;
    
    white.layer.cornerRadius = 0.03 * 300;
    
    [self.view addSubview:white];
    

    
    UILabel *DBTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 300, 44)];
    
    UILabel *DB = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, 300, 478/5)];
    
    
    DBTitle.text = @"✪动态背景需要下载吗？为什么动态背景在操作的时候会停止呢";
    
    DB.text = @"您好，我们的动态背景是采用高清视频播放的，为了您使用手机流畅和舒适，我们在您操作的时候，停止了视频的播放就会出现的情况，不过放心，我们的时候不需要用户下载，所以不用耗费流量的。";
    DB.lineBreakMode = UILineBreakModeWordWrap;
    DB.numberOfLines = 0;
    
    [white addSubview:DB];
    [white addSubview:DBTitle];
    
    
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
