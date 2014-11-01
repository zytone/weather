//
//  WeekWeather.m
//  WeatherForecast
//
//  Created by ckx on 14-10-25.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "WeekWeatherView.h"
#import "WeekCell.h"
#import "FutureWeekWeahterInfo.h"
@interface WeekWeatherView ()<UITableViewDataSource>
{
    UITableView  *aTableView; // 一周天气 tableView
}
@end
@implementation WeekWeatherView
+(instancetype)weekWeatherViewWith:(CGRect) rect
{
    return [[WeekWeatherView alloc]initWeekWeatherWith:rect];
}
-(instancetype)initWeekWeatherWith:(CGRect) rect
{
    if(self = [super initWithFrame:rect])
    {
        // 标题设置
        self.titleLabel.text = @"天气预报";
        // 未来七天tableView
        aTableView = [[UITableView alloc]
                      initWithFrame:RECT(0, TitleHeight, 285, 280)];
        aTableView.rowHeight = 40;
        aTableView.allowsSelection = NO;    // 禁止选择
        aTableView.scrollEnabled = NO;      // 禁止滚动
        aTableView.dataSource = self;       // 数据源代理
        aTableView.backgroundColor = [UIColor clearColor];
        [self addSubview:aTableView];
    }
    return self;
}
#pragma mark 设置表格数据
- (void )setData:(NSArray *)data
{
    
    _data = data;
    // 刷新数据柔柔弱弱ß
    [aTableView reloadData];
}

#pragma mark 数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cell的创建
    WeekCell *cell = [WeekCell cellWithTableView:tableView];
    // 设置数据
    FutureWeekWeahterInfo *futureDay = [[FutureWeekWeahterInfo alloc]init];
    futureDay = self.data[indexPath.row];
    [cell setFw:futureDay];
    return cell;
}

@end
