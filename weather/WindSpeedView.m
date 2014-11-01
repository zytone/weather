//
//  WindSpeedView.m
//  WeatherForecast
//
//  Created by ibokan on 14-10-27.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "WindSpeedView.h"

@interface WindSpeedView ()
{
    UIImageView *windCarImgView; // 风车图
    UILabel *WDLabel;            // 方向Label
    UILabel *WSLabel;            // 风速Label
}
@end
@implementation WindSpeedView

+(instancetype)windSpeedViewWith:(CGRect) rect
{
    return [[WindSpeedView alloc]initWindSpeedViewWith:rect];
}
-(instancetype)initWindSpeedViewWith:(CGRect) rect
{
    if(self =[super initWithFrame:rect])
    {
        // 设置标题文字
        self.titleLabel.text = @"风速";
        
        // 风车imageView
        UIImageView *bladeImageV = [[UIImageView alloc]initWithFrame:CGRectMake(60, 35+TitleHeight, 10, 60)];
        bladeImageV.image = [UIImage imageNamed:@"bigpole@2x"];
        [self addSubview:bladeImageV];
        windCarImgView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 5+TitleHeight, 70, 70)];
        windCarImgView.image = [UIImage imageNamed:@"blade_big@2x"];
        
        [self addSubview:windCarImgView];
        // 风车旋转
        // 风向label
        UILabel *WD_name = [[UILabel alloc]initWithFrame:CGRectMake(130, 15+TitleHeight, 45, 20)];
     
        WD_name.font = [UIFont systemFontOfSize:ContentFontSize];
        [WD_name setTextColor:[UIColor whiteColor]];
         WD_name.text = @"风向：";
        [self addSubview:WD_name];
        
        WDLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 15+TitleHeight, 80, 20)];
        WDLabel.font = [UIFont systemFontOfSize:ContentFontSize];
        [WDLabel setTextColor:[UIColor whiteColor]];
        WDLabel.text = @"东南风";
       
        [self addSubview:WDLabel];
        
        // 风力label
        UILabel *WS_name = [[UILabel alloc]initWithFrame:CGRectMake(130, 40+TitleHeight, 70, 20)];
    
        WS_name.font = [UIFont systemFontOfSize:ContentFontSize];
        WS_name.text = @"风力等级：";
        [WS_name setTextColor:[UIColor whiteColor]];
        [self addSubview:WS_name];
        
        WSLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 40+TitleHeight, 80, 20)];
        WSLabel.font = [UIFont systemFontOfSize:ContentFontSize];
        [WSLabel setTextColor:[UIColor whiteColor]];
        WSLabel.text = @"1级";
        [self addSubview:WSLabel];
        
    
    }
    return self;
}

#pragma 设置WindSpeedView数据
-(void)setNowWeatherInfo:(NowWeatherInfo *)nowWeatherInfo
{
    _nowWeatherInfo = nowWeatherInfo;
   
    WDLabel.text = nowWeatherInfo.WD;
    WSLabel.text = nowWeatherInfo.WS;
    
    // 由于nowWeatherInfo.WS数据格式为：2级 所以要去掉 “级”
    NSMutableString *strWS =  [NSMutableString stringWithString:nowWeatherInfo.WS];
    NSRange r = {strWS.length-1,1};
    [strWS replaceCharactersInRange:r withString:@""];
    
    // 经过测试0.2 可以相当 1级风
    CGFloat floatWS = 0.2 - ([strWS floatValue]+5)/100.0;
    [self revole:floatWS];
}
#pragma mark 风车动画
-(void)revole:(CGFloat)floatWS
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.delegate = self;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*0.1 , 0, 0, floatWS)];
    animation.duration = floatWS;
    animation.cumulative = YES;
    animation.repeatCount = INT_MAX;
    
    [windCarImgView.layer addAnimation:animation forKey:@"animation"];
}
@end
