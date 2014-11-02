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
#import "LineChartView.h"
@interface WeekWeatherView ()<UITableViewDataSource>
{
    UITableView  *aTableView; // 一周天气 tableView
    LineChartView  *lineChartView; // 折线图的view
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
        // 横线
//        UIView *line = [[UIView alloc]initWithFrame:RECT(20, CGRectGetMaxY(aTableView.frame)+10, 250, 1)];
//        line.backgroundColor = [UIColor whiteColor];
//        [self addSubview:line];
        UILabel *label = [[UILabel alloc]initWithFrame:RECT(20, CGRectGetMaxY(aTableView.frame)+10, 200, 20)];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextColor:[UIColor whiteColor]];
        label.text = @"一周每日平均温度趋势图：";
        [self addSubview:label];
        // 画图的view
        lineChartView = [[LineChartView alloc]initWithFrame:RECT(0, CGRectGetMaxY(aTableView.frame)+10, 320, 150)];
        
        NSMutableArray *pointArr = [[NSMutableArray alloc]init];
        
        //横轴
        NSMutableArray *hArr = [[NSMutableArray alloc]initWithCapacity:pointArr.count];
        [hArr addObject:@"今天"];
        [hArr addObject:@"周二"];
        [hArr addObject:@"周三"];
        [hArr addObject:@"周四"];
        [hArr addObject:@"周五"];
        [hArr addObject:@"周六"];
        [hArr addObject:@"周日"];
        [lineChartView setHDesc:hArr];
        
        [lineChartView setArray:pointArr];
        
        
        lineChartView.backgroundColor = [UIColor clearColor];
        [self addSubview:lineChartView];
        [self addSubview:aTableView];
    }
    return self;
}
#pragma mark 设置表格数据
- (void )setData:(NSArray *)data
{
    
    _data = data;
    // 刷新数据
    [aTableView reloadData];
    
    // 折线图
    
    NSMutableArray *pointArr = [[NSMutableArray alloc]init];
    
    //生成随机点
    int hInterva = 40;
    for(int i = 0 ; i< data.count;i++)
    {
        FutureWeekWeahterInfo *info = data[i];
        float average =([info.temp_high floatValue] + [info.temp_low floatValue])*0.5;
        [pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(hInterva*(i+1), average)]];
    }
    [lineChartView setArray:pointArr];

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
