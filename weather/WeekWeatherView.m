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

        UILabel *label = [[UILabel alloc]initWithFrame:RECT(20, CGRectGetMaxY(aTableView.frame)+10, 200, 20)];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextColor:[UIColor whiteColor]];
        label.text = @"一周每日温度趋势图：";
        [self addSubview:label];
        // 画图的view
        lineChartView = [[LineChartView alloc]initWithFrame:RECT(0, CGRectGetMaxY(aTableView.frame)+10, 320, 150)];
//        lineChartView.backgroundColor = [UIColor redColor];

        
        lineChartView.backgroundColor = [UIColor clearColor];
        
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
    
    NSMutableArray *pointArr = [NSMutableArray array];
    // 低点
    NSMutableArray *lowPointArr = [NSMutableArray array];
    //点信息
    int hInterva = 40;
    for(int i = 0 ; i< data.count;i++)
    {
        FutureWeekWeahterInfo *info = data[i];
        // 高点
        float high =[info.temp_high floatValue];
        [pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(hInterva*(i+1), high)]];
        // 低点
        float low = [info.temp_low floatValue];
        [lowPointArr addObject:[NSValue valueWithCGPoint:CGPointMake(hInterva*(i+1), low)]];
    }
    [lineChartView setArray:pointArr];
    [lineChartView setArrayLow:lowPointArr];
  
    //横轴
    NSMutableArray *hArr = [NSMutableArray array];
    for (int i = 0;i<data.count; i++) {
        FutureWeekWeahterInfo *info = data[i];
        if(i == 0)
        {
            [hArr addObject:@"今天"];
            continue;
        }
        NSRange r = {0,2};
        NSMutableString *oldWeekName =[NSMutableString stringWithString:info.week];
        [oldWeekName replaceCharactersInRange:r withString:@"周"];
        
        [hArr addObject:oldWeekName];
    }
    NSLog(@"hArr:%d",hArr.count);
    [lineChartView setHDesc:hArr];
    [self addSubview:lineChartView];
   
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
