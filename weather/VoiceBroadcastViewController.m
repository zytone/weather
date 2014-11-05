//
//  VoiceBroadcastViewController.m
//  help
//
//  Created by chan on 14-11-5.
//  Copyright (c) 2014年 chan. All rights reserved.
//

#import "VoiceBroadcastViewController.h"

@interface VoiceBroadcastViewController ()

@end

@implementation VoiceBroadcastViewController

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
    
    self.title = @"语音播报";
    
    
    
    UIView *white = [[UIView alloc]initWithFrame:CGRectMake(10, 80, 300, 568-90)];
    
    white.backgroundColor = [UIColor whiteColor];
    
    white.layer.masksToBounds = YES;
    
    white.layer.cornerRadius = 0.03 * 300;
    
    [self.view addSubview:white];
    
    
    
    
    
    
    
    UILabel *VBTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 300, 44)];
    
    UILabel *VB = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, 300, 478/5)];
    
    
    VBTitle.text = @"✪语音播报会自动打开吗?怎么关闭?";
    
    VB.text = @"我们的语音播报功能是手动控制的，需要的时候点击即可。当然，若然不需要用到，是不会贸贸然打开，不会打扰到您的心情和生活的。";
    VB.lineBreakMode = UILineBreakModeWordWrap;
    VB.numberOfLines = 0;
    
    [white addSubview:VB];
    [white addSubview:VBTitle];
    
    
    

    
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
