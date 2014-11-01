//
//  NotificationTableCellTableViewCell.m
//  PushChat
//
//  Created by YiTong.Zhang on 14-10-28.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import "NotificationTableCellTableViewCell.h"

@implementation NotificationTableCellTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  创建自定义cell
 *
 */
+ creatCell:(UITableView *)tableView
{
    NotificationTableCellTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"NotificationTableCellTableViewCell" owner:nil options:nil] lastObject];
    
    cell.switchNotification.on = YES;
    
    NSLog(@"state: %hhd",cell.switchNotification.on);
    
    return cell;
}




@end
