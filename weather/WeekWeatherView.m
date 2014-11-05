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
    UILabel *chartLineTitle;
    
    
    UILabel *errorLalel1;  // 数据为空出错提示
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
        
        // 图表小标题
        chartLineTitle = [[UILabel alloc]initWithFrame:RECT(20, CGRectGetMaxY(aTableView.frame)+10, 200, 20)];
        [chartLineTitle setFont:[UIFont systemFontOfSize:15]];
        [chartLineTitle setTextColor:[UIColor whiteColor]];
        [self addSubview:chartLineTitle];
        
        // 画图的view
        
        // 错误提示
        errorLalel1 = [[UILabel alloc]initWithFrame:RECT(25, 250, 300, 50)];
        [errorLalel1 setFont:[UIFont systemFontOfSize:13]];
        errorLalel1.text = @"由于网络故障或数据不存在，请求数据失败";
        errorLalel1.textColor = [UIColor whiteColor];
        [errorLalel1 setBackgroundColor:[UIColor clearColor]];
        [self addSubview:errorLalel1];
    }
    return self;
}
#pragma mark 设置表格数据
- (void )setData:(NSArray *)data
{
    _data = data;
    if(lineChartView !=nil)
    {
       
        [lineChartView removeFromSuperview];
    }
    lineChartView = [[LineChartView alloc]initWithFrame:RECT(0, CGRectGetMaxY(aTableView.frame)+10, 320, 150)];
    
    lineChartView.backgroundColor = [UIColor clearColor];
    [self addSubview:aTableView];

    
    if(_data !=nil)
    {
        // 显示标题
//        self.titleLabel.hidden = NO;
//        self.whiteLine.hidden = NO;
        // 显示tableView
        aTableView.hidden = NO;
        lineChartView.hidden = NO;
         chartLineTitle.hidden = NO;
        errorLalel1.hidden = YES;
        // 画图的view
        // 标题
        chartLineTitle.text = [NSString stringWithFormat:@"未来%d天每日温度趋势图：",data.count];
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
        // 高点
        [lineChartView setArray:pointArr];
        // 低点
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
        
        [lineChartView setHDesc:hArr];
        // 加入view中
        [self addSubview:lineChartView];
        
        // tableView刷新数据
        [aTableView reloadData];
    }else
    {
        aTableView.hidden = YES;
        lineChartView.hidden = YES;
        chartLineTitle.hidden = YES;
        errorLalel1.hidden = NO;
        
        // 隐藏标题
//        self.titleLabel.hidden = YES;
//        self.whiteLine.hidden = YES;
    }
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
