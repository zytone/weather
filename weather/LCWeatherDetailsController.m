//
//  LCWeatherDetailsController.m
//  WeatherForecast
//
//  Created by lrw on 14-10-21.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "LCWeatherDetailsController.h"
#import "LCBackgroundView.h"
#import "WeatherBriefView.h"
#import "WindSpeedView.h"
#import "LifeAdviceView.h"
#import "WeekWeatherView.h"
#import "GetWeatherData.h"
#import "GetWeatherData.h"
#import "FutureWeekWeahterInfo.h"
#import "LifeAdviceDetailsController.h"

@interface LCWeatherDetailsController () <UIScrollViewDelegate,LCHeadViewDelegate,GetWeatherDataDelegate,LifeAdviceViewDelegate,WeatherBriefViewDelegate>
{
    // ----------------
    WeatherBriefView *v0_BriefV;       // 1 当天天气内容简介 view
    WeekWeatherView *v1_weekWeatherV;// 2 一周天气 view
    LifeAdviceView *v2_lifeAdviceV;  // 3 生活建议 view
    WindSpeedView *v3_WindS;         // 4 风速 view
    // ----------------
}
@property (nonatomic , weak) UIView *contentView;
@end

@implementation LCWeatherDetailsController

-(void)loadView
{
    [super loadView];
    
    /**  头部View合拼  **/
    LCHeadView *headView = [[LCHeadView alloc]init];
    headView.delegate = self;
    headView.frame = RECT(VIEWPADDING, -REFRESHHEIGHT , self.view.width - 2 * VIEWPADDING, 2 * REFRESHHEIGHT);
    self.headView = headView;
    
    /**  上下滚动scrollView设置  **/
    float contentH = 3 * self.view.height;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:
                                RECT(0, REFRESHHEIGHT, self.view.width, self.view.height - REFRESHHEIGHT)];
    self.scrollView = scrollView;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = SIZE(0 , contentH);
    scrollView.delegate = self;
    
    /**  scrollView内容view  **/
    UIView *aView= [[UIView alloc]initWithFrame:RECT(0, 0, scrollView.width,contentH)];
    self.contentView = aView;
    [scrollView addSubview:aView];
    [self addViewToScrollViewContentView:aView];

    [self.view addSubview:scrollView];
    [self.view addSubview:headView];
}
// -------------------------------------------------
#pragma mark -返回背景视频名称 含有后缀：.mp4
-(int)getBackGroudVedioName
{
    NSString *name = v0_BriefV.futureWeekWeahterInfo.weather_icon2;
    int result = 0;
    if ([name isEqualToString:@"clear.mp4"]) result = 0;
    if ([name isEqualToString:@"n_rain.mp4"]) result = 1;
    if ([name isEqualToString:@"overcast.mp4"]) result = 2;
    if ([name isEqualToString:@"partlycloudy.mp4"]) result = 3;
    if ([name isEqualToString:@"rain.mp4"]) result = 4;
    if ([name isEqualToString:@"snow.mp4"]) result = 5;
    if ([name isEqualToString:@"wind.mp4"]) result = 6;
    return result;
}

#pragma mark - 设置数据(从数据库读取)
-(void)setAllDataByDB:(NSString *)cityNo
{
    // --------  数据库取出 --------
    // 即时天气
    NowWeatherInfo *nowInfo =[NowWeatherInfo searchLatestWeatherInfoByCityId:cityNo];
    
    // 一周天气（包括今天） 0是表示取出全部
    NSArray *futurInfoArry =[FutureWeekWeahterInfo searchLatestFutureWeatherByCityId:cityNo Count:0];
    
    // 生活指数
    NSArray *lifeItemArry = [LifeAdviceInfoItem searchLifeAdviceInfoItemsByCityId:cityNo Date:nil];
    
    // 判断数据是否为空
    NSLog(@"数据库中取出cityNo：%@",cityNo);
    if (futurInfoArry.count >0) {
        v0_BriefV.futureWeekWeahterInfo = futurInfoArry[0]; // 今天的天气放入天气简要view（由于nowInfo数据不全）
        v1_weekWeatherV.data = futurInfoArry;  // 数据放入一周天气view
    }else
    {
        // 置空
        v1_weekWeatherV.data = nil;
        v0_BriefV.futureWeekWeahterInfo = nil;
        NSLog(@"数据库取出一周FutureWeekWeahterInfo为空！");
    }
    if(nowInfo!=nil)
    {
        v3_WindS.nowWeatherInfo = nowInfo;     // 数据放入风速view
         v0_BriefV.nowWeatherInfo = nowInfo;    // 数据放入天气简要view
        
    }else
    {
        // 置空
        v3_WindS.nowWeatherInfo = nil;     // 数据放入风速view
        v0_BriefV.nowWeatherInfo = nil;    // 数据放入天气简要view
        NSLog(@"数据库取出即时天气NowWeatherInfo为空");
    }
    if (lifeItemArry.count >0) {
        v2_lifeAdviceV.lifeAInfos = lifeItemArry; //  数据放入生活建议view
        
    }else
    {
        // 置空
        v2_lifeAdviceV.lifeAInfos = nil; //  数据放入生活建议view
        NSLog(@"数据库取出生活LifeAdviceInfoItem为空");
    }
    
}
#pragma mark - 刷新数据(从网络请求)
-(void)updateAllDataByNet:(NSString *)cityNo
{
    
    NSLog(@"网络请求cityNO:%@",cityNo);
    //--------- 网络请求数据 ---------
    // 记录下城市id，以便补全网络上请求 生活指数数据的城市id属性

    // 1 实时天气信息
    NSString *path1  = [NSString stringWithFormat:@"http://www.weather.com.cn/data/sk/%@.html",cityNo];
    GetWeatherData *getNowWeather = [GetWeatherData getWeatherData:path1 Type:NOWWEATHER];
    getNowWeather.delegate = self;
    
    // 2 一周天气
    NSString *path2  =[NSString stringWithFormat:@"http://api.k780.com:88/?app=weather.future&weaid=%@&appkey=11415&sign=d30705ed84b4b4f7d46340727d509c78&format=json",cityNo];
    GetWeatherData *getWeekdata = [GetWeatherData getWeatherData:path2 Type:WEEKWEATHER];
    getWeekdata.delegate = self;
    
    // 3 生活建议
    NSString *path3  =[NSString stringWithFormat:@"http://www.weather.com.cn/data/zs/%@.html",cityNo];
    GetWeatherData *getLifedata = [GetWeatherData getWeatherData:path3 Type:LIFEADVICE];
    getLifedata.delegate = self;
}

// 2 设置数据
static int flag = 0;

#pragma mark - 网络数据请求结束 执行刷新标题的代理方法
-(void)excuteDelegateRefreshMethod
{
    if(flag==3)
    {
        if([self.delegate respondsToSelector:@selector(weatherDetailsController:headView:)])
        {
            [self.delegate weatherDetailsController:self headView:_headView];
            flag = 0;
        }
    }
}


#pragma mark -实现代理方法 获取实时天气信息 （GetWeatherDataDelegate）
-(void)getNowWeatherData:(NSDictionary *)dic errorMessage:(NSError *)err
{
    flag++;
    if (err == nil) {
        if(dic[@"weatherinfo"]!=nil)
        {
            NowWeatherInfo *info = [NowWeatherInfo nowWeatherInfoWithDict:dic[@"weatherinfo"]];
            // 1 每次请求都保存如数据库中(新的数据覆盖旧数据)
            [info insertNowWeatherInfo:info];
            // 2 天气简要view
            v0_BriefV.nowWeatherInfo = info;
            // 3 风速view
            v3_WindS.nowWeatherInfo = info;
            
            // 4 下拉刷新数据（如果请求结束收回标题）
            [self excuteDelegateRefreshMethod];
        }else
        {
            v0_BriefV.nowWeatherInfo = nil;
            // 3 风速view
            v3_WindS.nowWeatherInfo = nil;
            NSLog(@"请求实时天气信息为空");
        }
    }else
    {
        NSLog(@"获取实时天气信息失败，服务器出错!");
    }
}
#pragma mark -实现代理方法 获取一周天气信息
-(void)getWeekWeatherData:(NSDictionary *)dic errorMessage:(NSError *)err
{
    // 字典转模型
    flag++;
    if(err==nil)
    {
        
         // 判断数据是否为空
        if(dic[@"result"] != nil)
        {
            // 保存入数据库中（新数据覆盖旧数据）
            NSMutableArray *datas = [NSMutableArray array];
            for(NSDictionary *dict in dic[@"result"])
            {
                FutureWeekWeahterInfo *info = [FutureWeekWeahterInfo futureWeekWeatherInfo:dict];
                [info insertFutureWeekWeahterInfo:info];
                [datas addObject:info];
            }
            
            // 设置数据入view
            v1_weekWeatherV.data = datas;
        
              // wBriefV 获取今天的天气
              // 判断数组是否为空
             if(datas.count >0)
             {
               v0_BriefV.futureWeekWeahterInfo = datas[0];
             }
            //  下拉刷新数据（如果请求结束收回标题）
            [self excuteDelegateRefreshMethod];
        }else
        {
            //
            v1_weekWeatherV.data =nil;
            v0_BriefV.futureWeekWeahterInfo = nil;
            // 提示 数据请求失败
           
            NSLog(@"获取一周天气信息为空");
        }
    }else
    {
        NSLog(@"获取一周天气信息失败，服务器出错！");
    }
}
#pragma mark -实现代理方法 获取生活指数信息
-(void)getLifeAdviceData:(NSDictionary *)dic errorMessage:(NSError *)err
{
    flag++;
    if(err== nil)
    {
        if (dic[@"zs"]!=nil) {
        
        // 1 保存入数据库中
          //   1.0 补充数据完整，为字典dic增加一个字典cityid
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic[@"zs"]];
        [dict addEntriesFromDictionary:[NSDictionary dictionaryWithObject:_city_num forKey:@"cityid"]];
          //   1.1 多个模型转换为数组
        LifeAdviceInfo *life = [LifeAdviceInfo lifeAdviceInfoWithDict:dict];
          //   1.2 保存入数据库（新数据覆盖旧数据）
        for(LifeAdviceInfoItem *item in life.advsArry)
        {
            [item insertLifeAdviceInfoItem:item];
        }
        // 2 设置数据入 view
        v2_lifeAdviceV.lifeAInfos = life.advsArry;
        
        // 3 下拉刷新数据 （如果请求结束收回标题）
        [self excuteDelegateRefreshMethod];
        }else
        {
            v2_lifeAdviceV.lifeAInfos = nil;
              NSLog(@"获取生活指数信息为空");
        }
    }else
    {
        NSLog(@"获取生活建议信息失败，服务器出错!");
    }

}
// -----------------------------------------------------------
// 实现代理方法
-(void)lifeAdviceViewOnclick
{
#warning 点击生活建议推到那个controller（有待考虑）
    
}

- (void)alert
{
    MyLog(@"alertAction");
}
- (void)addViewToScrollViewContentView:(UIView *)contentView
{
    // ------------
   
    CGFloat padding = 10;
    //v0(天气简介)
    v0_BriefV = [WeatherBriefView weatherBriefView];
    v0_BriefV.delegate = self;
    [contentView addSubview:v0_BriefV];
    
    
    //v1 (一周天气预报)
    CGFloat v1W = 300;
    CGFloat v1H = 500;
    CGFloat v1X = padding;
    CGFloat v1Y = self.view.height - REFRESHHEIGHT + 10;
    v1_weekWeatherV = [WeekWeatherView weekWeatherViewWith:RECT(v1X, v1Y, v1W, v1H)];
    [contentView addSubview:v1_weekWeatherV];
    
    //v2 （生活建议view）
    CGFloat v2W = v1W;
    CGFloat v2H = 240;
    CGFloat v2X = v1X;
    CGFloat v2Y = v1Y + v1H + padding;
    v2_lifeAdviceV = [LifeAdviceView lifeAdviceViewWith:RECT(v2X, v2Y, v2W, v2H)];
    v2_lifeAdviceV.delegate =self;
    [contentView addSubview:v2_lifeAdviceV];
    
    //v3 （风速view）
    CGFloat v3W = v1W;
    CGFloat v3H = 160;
    CGFloat v3X = v1X;
    CGFloat v3Y = v2Y + v2H + padding;
    v3_WindS = [WindSpeedView windSpeedViewWith:RECT(v3X, v3Y, v3W, v3H)];
    [contentView addSubview:v3_WindS];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // KVO
    [self.headView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.headView beginLoading];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat headViewY = [[change valueForKey:@"new"] CGRectValue].origin.y;
    if (headViewY == 0) {
            if (_city_num) {
                [self updateAllDataByNet:_city_num];
            }
        if ([self.delegate respondsToSelector:@selector(weatherDetailsController:showRefresh:)]) {
            [self.delegate weatherDetailsController:self showRefresh:self.headView];
        }
    }
}

#pragma mark - setter / getter
-(void)setTopTitle:(NSString *)topTitle
{
    _topTitle = topTitle;
    self.headView.titleLabel.text = topTitle;
}

-(void)setCity_num:(NSString *)city_num
{
     _city_num = city_num;

    NSLog(@"初始化city_num:%@",city_num);
    
    [self setAllDataByDB:city_num];
    
//    [self updateAllDataByNet:city_num];
}

#pragma mark - Head view delegate
-(void)headViewDelegate:(LCHeadView *)headView button:(LCHeadButton)lcButton
{
    if ([self.delegate respondsToSelector:@selector(weatherDetailsController:topBtnClick:)])
        [self.delegate weatherDetailsController:self topBtnClick:lcButton];
}


#pragma mark - Scroll view delegate
static bool canRefresh = YES;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float contentY =  scrollView.contentOffset.y;
    
    if (contentY <= 0 && canRefresh) {
        CGRect headF = self.headView.frame;
        if (headF.origin.y < 0) {//移动headView位置，看起来就是随着scrollView下拉而被拉下来
            CGFloat headY = -REFRESHHEIGHT - contentY;
            headF.origin.y = headY <= 0 ? headY : 0;
            [UIView animateWithDuration:0.25 animations:^{
                self.headView.frame = headF;
            }];
        }
        //移动scrollView内容，效果：向下拉得时候内容没有移动
        UIView *view =  self.contentView;//contentView存放scrollView的内容View
        CGRect viewF = view.frame;
        viewF.origin.y = contentY;
        view.frame =viewF;
    }
    
    if ([self.delegate respondsToSelector:@selector(weatherDetailsController:scrollViewDidScroll:)]) {
        [self.delegate weatherDetailsController:self scrollViewDidScroll:scrollView];
    }  
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0) canRefresh = YES;
    else canRefresh = NO;
    
    if ([self.delegate respondsToSelector:@selector(weatherDetailsController:scrollViewWillBeginDragging:)]) {
        [self.delegate weatherDetailsController:self scrollViewWillBeginDragging:scrollView];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.delegate respondsToSelector:@selector(weatherDetailsController:scrollViewDidEndDragging:)]) {
        [self.delegate weatherDetailsController:self scrollViewDidEndDragging:scrollView];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(weatherDetailsController:scrollViewDidEndDecelerating:)]) {
        [self.delegate weatherDetailsController:self scrollViewDidEndDecelerating:scrollView];
    }
}

#pragma mark - Weather delegate
/**
 *   天气分享
 */
-(void)weatherBriefViewShareBtnClickWithNowWeather:(NowWeatherInfo *)nowInfo FutureWeekWeahterInfo:(FutureWeekWeahterInfo *)nowFutureInfo
{
    if ([self.delegate respondsToSelector:@selector(weatherDetailsControllerShareBtnClick:NowWeather:FutureWeekWeahterInfo:)]) {
        [self.delegate weatherDetailsControllerShareBtnClick:self NowWeather:nowInfo FutureWeekWeahterInfo:nowFutureInfo];
    }
}


@end
