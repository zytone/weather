//
//  AboutUsViewController.m
//  help
//
//  Created by chan on 14-11-5.
//  Copyright (c) 2014年 chan. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

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
    [super loadView];    // 针对ios7的适配
    if ([UIDevice currentDevice].systemVersion.intValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    
    self.navigationController.navigationBarHidden = NO;
    
    
    UIColor *bgc = [[UIColor alloc] initWithRed:225.0/255 green:225.0/255 blue:225.0/255 alpha:1];
    
    self.view.backgroundColor = bgc;
    
#pragma mark -尺寸
    
    CGRect RheadView = CGRectMake((320-80)/2, 40, 80, 80);
    CGRect Rversion = CGRectMake((320-140)/2, 110, 140, 80);
    CGRect Rright = CGRectMake((320-105)/2 + 10, 487-44, 120, 22);
    CGRect RcopyRight = CGRectMake(10,487-22, 320, 22);
    CGRect Rlogo = CGRectMake((320-110)/2-33, 487-44-11, 33, 33);
 
    
#pragma mark -标题
    self.title = @"关于";
    
#pragma mark -头像
    
    UIImage  *head = [UIImage imageNamed:@"icon_114.png"];
    
    UIImageView *headView = [[UIImageView alloc]initWithImage:head];
    
    headView.backgroundColor = [UIColor blackColor];
    
    headView.frame = RheadView;
    
    headView.layer.masksToBounds = YES;
    
    headView.layer.cornerRadius = 0.2f*80;
    
    [self.view addSubview:headView];
    
    
    UILabel *version =[[UILabel alloc]initWithFrame:Rversion];
    version.lineBreakMode = UILineBreakModeWordWrap;
    version.numberOfLines = 0;
    version.textAlignment = UITextAlignmentCenter;
    
    version.text = @"茶语天气 IOS版   CY1.0 正式版";
    
    version.font = [UIFont fontWithName:@"Arial" size:16];
    
    [self.view addSubview:version];
    
    
    UILabel *right = [[UILabel alloc]initWithFrame:Rright];
    
    right.text = @"茶语工作室  版权所有";
    
     right.font = [UIFont fontWithName:@"Arial" size:12];
   
    
    [self.view addSubview:right];
    
    UILabel *copyRight =[[UILabel alloc]initWithFrame:RcopyRight];
    
    copyRight.text = @"Copyright © 2014 TeaCulture Studio.All Rights Reserved.";
    
     copyRight.font = [UIFont fontWithName:@"Arial" size:12];
    
    [self.view addSubview:copyRight];
    
    
    UIImage *logo = [UIImage imageNamed: @"TeaCulture.png"];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logo];
    
    logoView.frame = Rlogo;
    
    [self.view addSubview:logoView];
    
    
    
    
    
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
