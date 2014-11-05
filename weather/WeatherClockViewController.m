//
//  WeatherClockViewController.m
//  help
//
//  Created by chan on 14-11-5.
//  Copyright (c) 2014年 chan. All rights reserved.
//

#import "WeatherClockViewController.h"

@interface WeatherClockViewController ()

@end

@implementation WeatherClockViewController

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
    
    
    self.title = @"天气闹钟";
    
    
    UIView *white = [[UIView alloc]initWithFrame:CGRectMake(10, 80, 300, 568-90)];
    
    white.backgroundColor = [UIColor whiteColor];
    
    white.layer.masksToBounds = YES;
    
    white.layer.cornerRadius = 0.03 * 300;
    
    [self.view addSubview:white];
    

    
    UILabel *WCTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 300, 44)];
    
    UILabel *WC = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, 300, 478/5)];
    
    
    WCTitle.text = @"✪使用天气闹钟，系统闹钟无法关闭";
    
    WC.text = @"天气闹钟和手机系统闹钟如果启用相同的闹钟时间，可能会导致部分机型在闹钟播放时无法停止，您可以在天气闹钟设置页面重新设置闹钟时间，或者修改系统闹钟时间以避免冲突。";
    WC.lineBreakMode = UILineBreakModeWordWrap;
    WC.numberOfLines = 0;
    [white addSubview:WCTitle];
    [white addSubview:WC];
    
    
    
    
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
