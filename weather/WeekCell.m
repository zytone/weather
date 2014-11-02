//
//  WeekCell.m
//  WeatherForecast
//
//  Created by ckx on 14-10-25.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "WeekCell.h"
#import "FutureWeekWeahterInfo.h"

@interface WeekCell ()
@property (weak, nonatomic) IBOutlet UILabel *week;
@property (weak, nonatomic) IBOutlet UILabel *weather;
@property (weak, nonatomic) IBOutlet UIImageView *weatherPic;
@property (weak, nonatomic) IBOutlet UILabel *temp;
@end


@implementation WeekCell


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"weekcell";
    WeekCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WeekCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setFw:(FutureWeekWeahterInfo *)fw
{
    _fw = fw;
    // 星期
    NSDate *date = [NSDate date];
    NSDateFormatter *dateF = [[NSDateFormatter alloc]init];
    [dateF setDateFormat:@"yyyy-MM-dd"];
    NSString *newDF = [dateF stringFromDate:date];
    
     if([newDF isEqualToString:fw.days])
        self.week.text =@"今天";
    else
      self.week.text =fw.week;
    // 天气
    self.weather.text = fw.weather;
    
    // 图片 通过天气判断采用那张图

    self.weatherPic.image = [UIImage imageNamed:fw.weather_icon];
    // 温度
    NSString *temp = [NSString stringWithFormat:@"%@~%@°C",fw.temp_high,fw.temp_low];
    self.temp.text = temp;//fw.temperature;
   
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
