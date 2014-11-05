//
//  HelpViewController.m
//  help
//
//  Created by chan on 14-11-5.
//  Copyright (c) 2014年 chan. All rights reserved.
//
/*
 
 如需改动，改掉行数  n  和 改掉arr内容就可以了
 
 */
#import "HelpViewController.h"
#import "VoiceBroadcastViewController.h"
#import "WeatherClockViewController.h"
#import "DynamicBackgroundViewController.h"
@interface HelpViewController ()

@end

@implementation HelpViewController

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
    // 针对ios7的适配
    if ([UIDevice currentDevice].systemVersion.intValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"使用帮助";
#pragma mark -table 行数、
    int n = 3;
    
#pragma mark -尺寸
    CGRect Rtable =CGRectMake(0, 0, 320, 44*n);
    
#pragma mark -颜色
    UIColor *CBg = [[UIColor alloc] initWithRed:248.0/255 green:248.0/255 blue:249.0/255 alpha:1];
    
#pragma mark -背景颜色
    self.view.backgroundColor = CBg;
    
#pragma mark -table
    
    table = [[UITableView alloc]initWithFrame:Rtable];
    
    table.delegate = self;
    
    table.dataSource = self;
    
    table.scrollEnabled = NO;
    
    [self.view addSubview:table];
    
#pragma mark -table的行内容
    arr = [[NSMutableArray alloc]initWithObjects:@"语音播报",@"天气闹钟",@"动态背景" ,nil];
    
    
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark -tableView 每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}

#pragma mark -只支持竖屏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation

{
    
    // Return YES for supported orientations
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    NSLog(@"%d",arr.count);
    static NSString *CellIdentifier = @"Cell";
    
    //初始化cell并指定其类型，也可自定义cell
    
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == NULL)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    [[cell textLabel]setText:[arr objectAtIndex:indexPath.row]];
    
#pragma mark -设置cell的属性
    //右边的箭头标志
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark -响应选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"did selectrow");
    
    
    if (indexPath.row == 0) {
        
#warning pushToVoiceBroadcast  /  VB
        
        VoiceBroadcastViewController *voi = [VoiceBroadcastViewController new];
        
        voi.title = @"语言播报";
        
        [self.navigationController pushViewController:voi animated:YES];
        
        NSLog(@"1");
       
        
    }
    if (indexPath.row == 1) {
       
#warning pushToWeatherClock    /  WC
        
        WeatherClockViewController *wc = [WeatherClockViewController new];
        wc.title = @"天气闹钟";
        [self.navigationController pushViewController:wc animated:YES];
        
        NSLog(@"2");
       
    }
    if (indexPath.row ==2) {
#warning pushToDynamicBackground
        DynamicBackgroundViewController *dy = [DynamicBackgroundViewController new];
        
        dy.title = @"动态背景";
        
        [self.navigationController pushViewController:dy animated:YES];
        
        NSLog(@"3");
    }
    
    
    
    
    
    
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
