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
}


@end

@implementation SettingTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *arr = @[@"拍照",@"提醒",@"生活指数"];
        
        mArr = arr;
        self.backgroundColor = [UIColor whiteColor];
        [self creatTabelWithFrame:frame];
    }
    return self;
}

- (void) creatTabelWithFrame:(CGRect)frame
{
    
    settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(VIEW_X, 0, VIEW_WIDTH, VIEW_HEIGHT) style:UITableViewStyleGrouped];
    settingTableView = [[UITableView alloc] initWithFrame:frame];
    
    settingTableView.dataSource = self;
    
    settingTableView.delegate = self;
    
    [self addSubview:settingTableView];
//    self = settingTableView;
//    return settingTableView;
    

}


#pragma mark - setting的数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return mArr.count + 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        SettingHeadTableViewCell *headCell = [SettingHeadTableViewCell creatCell:tableView];
        
        headCell.info = @[@"ad_01",@"zyt"];
        
        return headCell;
    }
    else{
        SettingInfoTableViewCell *cell = [SettingInfoTableViewCell creatCell:tableView];
        
        cell.labelInfo = mArr[indexPath.row - 1 ];
        
        if (indexPath.row == 2 || indexPath.row == 3) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    }
    //    NSLog(@"%d",indexPath.row);
    
    //    return cell;
    NSLog(@"111111111---------------------1");
}

/**
 *  tableViewCell 点击效果
 *
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击cell行时，背景颜色一闪而过
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSLog(@"indexPath.row : %d",indexPath.row);
    
    [self.delegate settingTableCellDidClickWithIndex:indexPath.row];
}

/**
 *
 *  设置cell的高度
 *
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 55;
    }
    return 40;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect r = self.superview.frame;
    
//    settingTableView.frame = r;
//    NSLog(@"%@",r);
    NSLog(@"table self :%@",self);
}


@end
