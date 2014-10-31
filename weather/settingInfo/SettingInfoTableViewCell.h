//
//  SettingInfoTableViewCell.h
//  PushChat
//
//  Created by YiTong.Zhang on 14/10/30.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingInfoTableViewCell : UITableViewCell

@property (nonatomic , strong) NSString *labelInfo;

+ (instancetype) creatCell:(UITableView *)tableView;

@end
