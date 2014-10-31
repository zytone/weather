//
//  SettingInfoTableViewCell.m
//  PushChat
//
//  Created by YiTong.Zhang on 14/10/30.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import "SettingInfoTableViewCell.h"

@interface SettingInfoTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *titleInfo;


@end

@implementation SettingInfoTableViewCell

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
 *  我们在SettingInfoTableViewCell里面实现cell的创建
 *
 *  @param tableView 要添加cell的tableView
 *
 *  @return 返回一个cell
 */
+ (instancetype)creatCell:(UITableView *)tableView
{
    // 做一个标记，用于区别每一个cell
    static NSString *ID = @"setting";
    
    SettingInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    if (cell == nil) {
        // 在创建cell的时候，使用Xib
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingInfoTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    return cell;
}

// 设置cell里面的信息
- (void)setLabelInfo:(NSString *)labelInfo
{
    self.titleInfo.text = labelInfo;
    
    self.titleInfo.font = [UIFont fontWithName:@"Helvetica" size:12];
    
    _labelInfo = labelInfo;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews ];
    
    float h = self.frame.size.height;
    
    float fontSize = 12 * (h / 45.0);
    
    self.titleInfo.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    
}

@end
