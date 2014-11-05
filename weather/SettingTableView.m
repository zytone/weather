//
//  SettingTableView.m
//  weather
//
//  Created by YiTong.Zhang on 14/10/31.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import "SettingTableView.h"
// 视图头文件
#import "SettingInfoTableViewCell.h"
#import "SettingHeadTableViewCell.h"


#define VIEW_WIDTH self.frame.size.width
#define VIEW_HEIGHT self.frame.size.height
#define VIEW_X self.frame.origin.x
#define VIEW_Y self.frame.origin.y

@interface SettingTableView () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *settingTableView;
    
    // 存放每一个行的主要内容
    NSArray *mArr;
    
    // 组的标题
    NSArray *sArr;
    
    // 版本
    NSString *updateTime;
}


@end

@implementation SettingTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *arr1 = @[@"拍照",@"提醒",@"生活指数"];
        
        NSArray *arr2 = @[@"检查更新",@"帮助",@"关于我们"];
        
        sArr = @[@"个人设置",@"应用相关"];
        
        mArr = @[arr1,arr2];
        
        updateTime = @"1.0.0";
        
        [self creatTabelWithFrame:frame];
    }
    return self;
}

- (void) creatTabelWithFrame:(CGRect)frame
{
    
    settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(VIEW_X, 0, VIEW_WIDTH, VIEW_HEIGHT) style:UITableViewStyleGrouped];
    
    
    settingTableView.backgroundColor = [UIColor colorWithRed:60/254.0 green:60/254.0 blue:60/254.0 alpha:1];

    
    settingTableView.dataSource = self;
    
    settingTableView.delegate = self;
    
    //
    settingTableView.sectionFooterHeight = 0;
    
    // 接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChange:) name:@"userChange" object:nil];

    [self addSubview:settingTableView];
    

}


#pragma mark - setting的数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return mArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = mArr[section];
    if (section == 0) {
        return arr.count + 1;
    }
    return arr.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = mArr[indexPath.section];
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        SettingHeadTableViewCell *headCell = [SettingHeadTableViewCell creatCell:tableView];
        
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *dic = [user objectForKey:@"userInfo"];
        
        if (dic == nil) {
            dic = @{@"userName": @"未登录", @"photoName":@"right_drawer_head_unlogin_press.png"};
        }
        
        headCell.info = @[dic[@"photoName"],dic[@"userName"]];
        
        
        headCell.backgroundColor = [UIColor colorWithRed:60/254.0 green:60/254.0 blue:60/254.0 alpha:1];
        
        return headCell;
    }
    else{
        SettingInfoTableViewCell *cell = [SettingInfoTableViewCell creatCell:tableView];
        
        int index = indexPath.row;
        
        if (indexPath.section == 0) {
            index --;
        }
        
        cell.labelInfo = arr[index];
        // 版本
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.rightLabel.text = updateTime;
        }
        
        cell.backgroundColor = [UIColor colorWithRed:60/254.0 green:60/254.0 blue:60/254.0 alpha:1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSLog(@"%d",indexPath.row);
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
    
    [self.delegate settingTableCellDidClickWithIndex:indexPath];
}

/**
 *
 *  设置cell的高度
 *
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0 ) {
        return 65;
    }
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"个人设置";
            break;
            
        case 1:
            return @"应用相关";
            break;
            
        default:
            return @"";
            break;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 40)];
//    
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
//    lab.text = sArr[section];
//    
//    [view addSubview:lab];
//    
//    return view;
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


- (void) userChange : (id)sender
{
    
    [settingTableView  reloadData];
    
//    NSArray *mSet = settingTableView.subviews;
    
    NSLog(@"执行了tableview里面，reloadData  %@",settingTableView  );
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 登录信息











@end
