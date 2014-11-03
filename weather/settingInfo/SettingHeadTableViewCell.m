//
//  SettingHeadTableViewCell.m
//  PushChat
//
//  Created by YiTong.Zhang on 14/10/30.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import "SettingHeadTableViewCell.h"

@interface SettingHeadTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation SettingHeadTableViewCell

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
    static NSString *ID = @"settingHead";
    
    SettingHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    if (cell == nil) {
        // 在创建cell的时候，使用Xib
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingHeadTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    return cell;
}

// 设置cell里面的东西
- (void)setInfo:(NSArray *)info
{
    self.headImg.image = [UIImage imageNamed:@"head"];
    
    self.headImg.layer.masksToBounds = YES;
    
    self.headImg.layer.cornerRadius = 25;
    
    self.headImg.backgroundColor = [UIColor blackColor];
    
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",info[1]];
    
    NSLog(@"执行了这里 %@",info[0]);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float h = self.frame.size.height;
    
    float fontSize = 12 * (h / 45.0) ;
    
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    
//    NSLog(@"cell:%@",self);
    
}



@end
