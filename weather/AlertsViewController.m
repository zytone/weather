//
//  AlertsViewController.m
//  weather
//
//  Created by YiTong.Zhang on 14-10-22.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import "AlertsViewController.h"
#import "NotificationTableCellTableViewCell.h"
#import "NotificationOperate.h"
#import "LCLocationController.h"
#import "LCWeatherDetailsController.h"
#import "MBProgressHUD/MBProgressHUD+MJ.h"
#import "NowWeatherInfo.h"
#import "FutureWeekWeahterInfo.h"

#define VIEW_WIDTH self.view.frame.size.width
#define VIEW_HEIGHT self.view.frame.size.height
#define VIEW_X self.view.frame.origin.x
#define VIEW_Y self.view.frame.origin.y

// 定义存储在NSUserDefaults中的key
#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
#define KEY @"notification"
#define TIME @"notificationTime"
#define STATUS @"switchStatus"

@interface AlertsViewController ()<UITableViewDataSource,NotificationTableCellTableViewCellDelegate,UITableViewDelegate,LCLocationControllerDelegate>
{
    UIDatePicker *dates;
    UIView *dateView;
    UITableView *dateTableView;
    // 通知开关的cell
    NotificationTableCellTableViewCell *cellSw;
    
    // 通知开关状态
    BOOL aStatus;
}
// 接收请求的数据
@property (nonatomic , strong) NSMutableData *requestData;

// 获取当天天气数据
//@property (nonatomic , strong) NowWeatherInfo *nowWeatherInfo;

- (void) creatLocalNotification;


@end

@implementation AlertsViewController

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
    
    
    // 针对ios7的适配
    if ([UIDevice currentDevice].systemVersion.intValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    // 显示返回按钮
//    self.navigationController.navigationBar.hidden = NO;
    
    aStatus = NO;
    
    // 创建一个遮蔽层
    UIButton *cover = [[UIButton alloc] initWithFrame:self.view.frame];
    
    [cover setBackgroundColor:[UIColor grayColor]];
    cover.alpha = 0.5;
    
    cover.tag = 100;
    
    cover.hidden = YES;
    
    [self.view addSubview:cover];
    
    
    // 创建一个view用来存放时间选择
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 568, 320, 220)];
    
    dateView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:dateView];
    
    
    //    // 最小时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"HH:mm:ss"];
    
    NSDate *minDate= [dateFormatter dateFromString:@"06:30:00"];
    
    NSDate *maxDate = [dateFormatter dateFromString:@"23:59:00"];
    
    // 1、创建一个时间选择器
    dates = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 20, 320, 200)];
    
    // 2、选择一个选择器的样式
    dates.datePickerMode = UIDatePickerModeCountDownTimer;
    
    // 3、设置选择器的最大最小日期或时间
    dates.minimumDate = minDate;
    dates.maximumDate = maxDate;
    
    // 4、设置当前时间
    dates.date = minDate;
    
    [dateView addSubview:dates];
    
    // 在选择器的上方添加一个view
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    topView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0
                                              alpha:1];
    
    [dateView addSubview: topView];
    
    // 在dateView中添加两个按钮
    
    // 1、取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    cancelBtn.frame = CGRectMake(10, 6, 40, 25);
    
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    cancelBtn.tag = 11;
    [cancelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelBtn];
    
    // 2、完成按钮
    UIButton *done = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [done setTitle:@"完成" forState:UIControlStateNormal];
    [done setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    done.frame = CGRectMake(270, 6, 40, 25);
    
    done.layer.borderWidth = 1;
    done.layer.cornerRadius = 5;
    done.layer.borderColor = [[UIColor grayColor] CGColor];
    done.tag = 12;
    [done addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:done];
    
    // 3、添加一个标题
    UILabel *headTitle = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100, 40)];
    
    headTitle.text = @"预报时间";
    headTitle.textColor = [UIColor blackColor];
    headTitle.textAlignment = NSTextAlignmentCenter;
    //    headTitle.font = [UIFont fontWithName:@"sonti" size:27];
    [topView addSubview:headTitle];
    
    
    // 读取已经是否有存储的数据
    [self readDataWithKey:KEY];
    
    
    
    // 添加一个tableView
    dateTableView = [[UITableView alloc] initWithFrame:CGRectMake(VIEW_X, -20, VIEW_WIDTH, VIEW_HEIGHT) style:UITableViewStyleGrouped];
    dateTableView.dataSource = self;
    dateTableView.delegate = self;
    
    [self.view addSubview:dateTableView];
    
    [self.view sendSubviewToBack:dateTableView];
    
    [self getCurrLocationWeatherInfo];
}

/**
 *  读取useDefaults里面的数据
 *
 *  @param aKey 对应的key值
 */
- (void)readDataWithKey:(NSString *)aKey
{
    // 直接用一个字符串来进行接收
    //    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:aKey];
    
    NSDictionary *dic = [USER_DEFAULTS objectForKey:aKey];
    
    if (dic != nil) {
        // 开关状态
        NSNumber *num = dic[STATUS];
        
        aStatus = num.boolValue;
        
        // 获取之前设置的时间
        NSDate *d = dic[TIME];
        
        // 1\设置选择器时间
//        [self settingDate];
        dates.date = d ;
        
        cellSw.switchNotification.on = aStatus;
        // 2\设置通知
        [self creatOrCancelNotificationWithState:aStatus];
        
        NSLog(@"dic : %@",dic);
    
    }
    else
    {
        NSLog(@"这里没有存在历史记录！~");
    }
    
}

/**
 *  保存设置到userdefaults中
 *
 */
- (void) saveDataWithDictionary:(NSDictionary *)dic
{
    
    // 设置数据
    [USER_DEFAULTS setObject:dic forKey:KEY];
    
    // 更新数据，本地的
    [USER_DEFAULTS synchronize];

}

#pragma mark - 获取所定位城市的天气情况
-(void)getCurrLocationWeatherInfo
{
    LCLocationController *loca = [LCLocationController new];
    // 获取位置信息
    [loca update];
    [self addChildViewController:loca];
    [MBProgressHUD hideHUD];
    loca.delegate =self;
}

-(void)locationController:(LCLocationController *)locationController result:(NSDictionary *)result
{
    NSMutableString *cityName1 =result[@"city"];
    
    
    NSArray *arry =[cityName1 componentsSeparatedByString:@"."];
    
    NSString *cityName = [arry lastObject];

    if(cityName)
    {
        NowWeatherInfo *nowInfo = [NowWeatherInfo searchLatestWeatherInfoByCityName:cityName];
        FutureWeekWeahterInfo *todayInfo = [FutureWeekWeahterInfo searchTodayWeatherByCityName:cityName];
        
        NSMutableString *weatherInfo = [NSMutableString string];
        if(nowInfo)
        {
            [weatherInfo appendFormat:@"%@,",nowInfo.city];
            [weatherInfo appendFormat:@"体感 %@℃,",nowInfo.temp];
        }
        if(todayInfo)
        {
            [weatherInfo appendFormat:@"%@,",todayInfo.days];
            [weatherInfo appendFormat:@"%@,",todayInfo.weather];
            [weatherInfo appendFormat:@"%@.",todayInfo.temperature];
        }
        if(!weatherInfo)
        {
            [weatherInfo appendString:@"天气信息不可用"];
        }
        self.curLocationweatherInfo = weatherInfo;
    }
    
#warning 输出天气信息在这里
    NSLog(@" 输出天气信息在这里 %@",self.curLocationweatherInfo);
}

/**
 *  设置tableView的cell
 *
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        cellSw = [NotificationTableCellTableViewCell creatCell:tableView];
        
        cellSw.delegate = self;
        
        cellSw.switchNotification.on = aStatus;
        cellSw.switchNotification.tag = 111;
        
        [cellSw.switchNotification addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        
        return cellSw;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"NotifiCell"];
        cell.textLabel.text = @"预报时间";
        cell.textLabel.font = [UIFont fontWithName:@"Systemt" size:15];
        
        // 直接获取设置的时间
        cell.detailTextLabel.text = [self stringTransformByDate:dates.date];
        
        
        
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
        
    }
}

/**
 *  tableViewCell 点击效果
 *
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击cell行时，背景颜色一闪而过
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 1) {
        [self animationByDatePicker];
    }
    
}

/**
 *  时间选择器的消失和出现的动画
 *
 */
- (void) animationByDatePicker
{
    // 显示遮盖层
    UIButton *cover = (UIButton *) [self.view viewWithTag:100];
    
    
    static int i = 1;
    // 弹出时间选择器
    if (i % 2 == 1) {
        cover.hidden = NO;
        [UIView animateWithDuration:0.30 animations:^{
            dateView.frame = CGRectMake(0, 278, 320, 568) ;
        }];
        i++;
        
    }
    else
    {
        i++;
        [UIView animateWithDuration:0.3 animations:^{
            // 移出界面
            dateView.frame = CGRectMake(0, 568, 320, 568) ;
        } completion:^(BOOL finished) {
            // 隐藏遮蔽层
            cover.hidden = YES;
        }];
    }
}

/**
 *  在dateView中的两个按钮触发的方法：取消和完成
 *
 */
- (void) clickBtn:(UIButton *)aBtn
{
    int temp = aBtn.tag;
    // 点击的是完成按钮
    if (temp == 12) {
        aStatus = YES;
        // 改变按钮状态
        [self creatOrCancelNotificationWithState:aStatus];
        
        // 刷新tableView的数据
        [dateTableView reloadData];
        
//        cellSw.switchNotification.hidden = YES;
        
        NSLog(@"status: %d",cellSw.switchNotification.on);
        
        NSNumber *num = [NSNumber numberWithBool:aStatus];
        
        // 保存信息到userdefualts
        NSDictionary *dic = @{TIME: dates.date, STATUS : num};
        
        [self saveDataWithDictionary:dic];
        
    }
    
    [self animationByDatePicker];
}

#pragma mark - 数据格式装换
- (NSString *) stringTransformByDate : (NSDate *)aDate
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    // 单单取出小时和分钟
    NSDateComponents *dateComp = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:dates.date];
    
    // 格式转换
    NSString *dateStr = [NSString stringWithFormat:@"%d:%d",dateComp.hour ,dateComp.minute];
    
    return dateStr;
}

/**
 *  设置开关按钮的代理方法，状态发生改变的时候触发
 *
 */
- (void)notificationTabelCellTabelCell:(UITableViewCell *)cell withSwitchState:(BOOL)aState
{
    NSLog(@"这里是ctroll，已经接收到了状态的改变通知");
}


/**
 *  时间设置
 *
 */
- (void) settingDate
{
    
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    // 获取当天时间的年月日
    NSDateComponents *nowComps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:[NSDate date]];
    
    // 获取选择的时间：时 分
    NSDateComponents *selectComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[dates date]];
    
    // 设置时间
    [selectComponents setYear:[nowComps year]];
    [selectComponents setMonth:[nowComps month]];
    [selectComponents setDay:[nowComps day]];
    
    NSLog(@"component : %@",[calendar dateFromComponents:selectComponents]);
    
    dates.date = [calendar dateFromComponents:selectComponents];
    
}

/**
 *  开关控件的状态改变后触发
 *
 */
- (void) switchChange:(UISwitch *)aSwitch
{
    // 执行通知的添加与取消
    
    // 处理选择的时间日期
    [self settingDate];
    
    [self creatOrCancelNotificationWithState:aSwitch.on];
    
    BOOL stat = aSwitch.on;
    
    NSNumber *num = [NSNumber numberWithBool:stat];
    
    // 保存信息到userdefualts
    NSDictionary *dic = @{TIME: dates.date, STATUS : num };
    [self saveDataWithDictionary:dic];
}

/**
 *  创建和取消通知
 *
 */
- (void)creatOrCancelNotificationWithState:(BOOL)b
{
    
    NSString *key = @"name";
    NSString *value = @"test";
    
    if (YES == b) {
        
        NSDictionary *info = [NSDictionary dictionaryWithObject:value forKey:key];
        [NotificationOperate creatNotificationWithInfo:info withTime:dates.date withMessage:@"我有一条通知要让你看到"];
    }
    else
    {
        [NotificationOperate stopNotificationWithValue:value withKey:key];
    }
    
}

/**
 *  点击时间，获取时间选择器的值
 *
 */
- (void) datePicker:(UIButton *)aBtn
{
    // 处理选择的时间日期
    [self settingDate];
    
    // 重设本地通知时间  zyt
    NSLog(@"select date : %@",dates.date);
}


/**
 *  视图即将出现时，添加bar
 */

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [super viewWillAppear:animated];
}



@end
