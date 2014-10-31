//
//  LCShareController.m
//  WeatherForecast
//
//  Created by lrw on 14/10/30.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "LCShareController.h"
#import "FutureWeekWeahterInfo.h"
#import "NowWeatherInfo.h"

#define ShareButtonBeginTag 1000
//分享按钮个数
#define ShareButtonCount 3
@interface LCShareController ()
/**
 *  分享的内容
 */
@property (nonatomic, strong) FutureWeekWeahterInfo *weekWeather;
@property (nonatomic, strong) NowWeatherInfo *nowWeather;
/**
 *  要显示分享的view
 */
@property (nonatomic , weak) UIView *showView;
/**
 *  存放所有要显示的子控件的view
 */
@property (nonatomic , weak) UIView *bgView;
/**
 *  背景按钮,点击隐藏showView
 */
@property (nonatomic , weak) UIButton *bgBtn;
/**
 *  存放分享按钮的view
 */
@property (nonatomic , weak) UIView *contentView;
@end

@implementation LCShareController

+ (instancetype)shareWithView:(UIView *)view
{
    LCShareController *controller = [LCShareController new];
    controller.showView = view;
    return controller;
}

-(void)addBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(showShareViewWithFutureWeekWeahterInfo:NowWeatherInfo:) forControlEvents: UIControlEventTouchUpInside];
    [self.showView addSubview:btn];
}

#pragma mark - 按钮点击事件

/**
 *  显示分享
 */
-(void)showShareViewWithFutureWeekWeahterInfo:(FutureWeekWeahterInfo *)futureWeekWeahterInfo NowWeatherInfo:(NowWeatherInfo *)nowWeatherInfo
{
    //要分享的内容
    self.weekWeather = futureWeekWeahterInfo;
    self.nowWeather = nowWeatherInfo;
    
    //背景
    UIView *bgView = [[UIView alloc]initWithFrame:_showView.bounds];
    _bgView = bgView;
    
    //背景按钮
    UIButton *bgBtn = [[UIButton alloc]initWithFrame:_showView.bounds];
    _bgBtn = bgBtn;
    bgBtn.backgroundColor = [UIColor blackColor];
    bgBtn.alpha = 0;
    [bgBtn addTarget:self action:@selector(hideShareView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:bgBtn];
    
    //存放内容的view
    [self addContentView];
    
    //显示内容
    [_showView addSubview:bgView];
    [UIView animateWithDuration:0.25 animations:^{
        _bgBtn.alpha = 0.5;
        float ctVFY = _showView.height - _contentView.height;
        CGRect ctVF = _contentView.frame;
        ctVF.origin.y = ctVFY;
        _contentView.frame = ctVF;
    }];
}

/**
 *  隐藏分享
 */
- (void)hideShareView
{
    [UIView animateWithDuration:0.25 animations:^{
        _bgBtn.alpha = 0;
        CGRect ctVF = _contentView.frame;
        ctVF.origin.y = _showView.height;
        _contentView.frame = ctVF;
    } completion:^(BOOL finished) {
        [[_showView.subviews lastObject] removeFromSuperview];
    }];
}

/**
 *  点击按钮，分享内容
 */
- (void)share:(UIButton *)btn
{
    int tag = btn.tag;
    if (tag == ShareButtonBeginTag + 1) {//QQ空间分享
        
    }
    else if(tag == ShareButtonBeginTag + 2)//朋友圈分享
    {
        
    }
    else//新浪微博分享
    {
        
    }
}

#pragma mark - view设置

/**
 *  添加存放内容的view
 */
- (void)addContentView
{
    float superViewW = _showView.width;
    float superViewH = _showView.height;
    float ctVW = superViewW;
    float ctVH = 100;
    UIView *contentView = [[UIView alloc]initWithFrame:RECT(0, superViewH, ctVW, ctVH)];
    _contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    UIButton *contentBtn = [[UIButton alloc]initWithFrame:contentView.bounds];
    [contentBtn addTarget:self action:@selector(hideShareView) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:contentBtn];
    [_bgView addSubview:contentView];//把内容放在背景里面
    
    //添加分享种类(按钮)
    [self addShareBtn:contentView];
}

/**
 *  添加分享按钮
 */
- (void)addShareBtn:(UIView *)contentView
{
    float btnH = 60;
    float btnW = 60;
    float btnY = (contentView.height - btnH) * 0.5;
    float margin = (contentView.width - ShareButtonCount * btnW) / (ShareButtonCount + 1);
    
    for (int i = 0; i < ShareButtonCount; i++) {
        float btnX = margin + i * (margin + btnW);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = (i + 1) * ShareButtonBeginTag;
        [btn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self addBtnImageBtn:btn index:i];//添加按钮背景图片
        btn.frame = RECT(btnX, btnY, btnW, btnH);
        [contentView addSubview:btn];
    }
}

/**
 *  添加按钮图片
 */
- (void)addBtnImageBtn:(UIButton *)btn index:(int)i
{
    NSString *normalImageName = [NSString stringWithFormat:@"share_%d_normal",i];
    NSString *pressedImageName = [NSString stringWithFormat:@"share_%d_pressed",i];
    
    UIImage *normalImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:normalImageName ofType:@"png"]];
    UIImage *pressedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pressedImageName ofType:@"png"]];
    
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:pressedImage  forState:UIControlStateHighlighted];
}

@end
