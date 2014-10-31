//
//  NotificationTableCellTableViewCell.h
//  PushChat
//
//  Created by YiTong.Zhang on 14-10-28.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

 /// 设置一个协议
@protocol NotificationTableCellTableViewCellDelegate <NSObject>

-(void)notificationTabelCellTabelCell:(UITableViewCell *)cell withSwitchState:(BOOL) aState;

@end

@interface NotificationTableCellTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UISwitch *switchNotification;

@property (strong , nonatomic) id<NotificationTableCellTableViewCellDelegate> delegate;

+ creatCell:(UITableView *)tableView;


- (void) changeSwitchs:(UISwitch *)aSwitch;
@end
