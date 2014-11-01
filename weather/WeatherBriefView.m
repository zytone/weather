//
//  WeatherBriefView.m
//  WeatherForecast
//
//  Created by ibokan on 14-10-22.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "WeatherBriefView.h"
#import "ToolHelper.h"
#import "ZCNoneiFLYTEK.h"
#import <AVFoundation/AVFoundation.h>
// 声明和初始化整个程序使用的变量
extern bool isEndFlag = false;
@interface WeatherBriefView ()<AVAudioPlayerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *temp;
@property (weak, nonatomic) IBOutlet UILabel *tempUnit;

@property (weak, nonatomic) IBOutlet UILabel *SD;
@property (weak, nonatomic) IBOutlet UILabel *WD;
@property (weak, nonatomic) IBOutlet UILabel *WS;
@property (weak, nonatomic) IBOutlet UILabel *time;

// 音频播放
@property(nonatomic,retain)AVAudioPlayer *aPlayer;
@property(nonatomic,retain)ZCNoneiFLYTEK *speekingVoice;
// 分享按钮
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

// 分享事件
- (IBAction)shareClick:(UIButton *)sender;

// 声音按钮
@property (weak, nonatomic) IBOutlet UIButton *voice;
- (IBAction)voiceClick:(UIButton *)sender;

@end
@implementation WeatherBriefView
@synthesize nowWeatherInfo = _nowWeatherInfo;
@synthesize futureWeekWeahterInfo =_futureWeekWeahterInfo;
+(instancetype)weatherBriefView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"WeatherBriefView" owner:nil options:nil]lastObject];
}

-(void)setNowWeatherInfo:(NowWeatherInfo *)nowWeatherInfo
{
    
    _nowWeatherInfo = nowWeatherInfo;
    
    self.temp.text = nowWeatherInfo.temp;
    // 设置单位的位置紧靠temp
    // 1获取temp文字的宽度
    ToolHelper *tool = [ToolHelper toolHepler]; //工具类
    
    CGSize titleSize = [tool sizeWithText:self.temp.text font:self.temp.font maxSize:CGSizeMake(MAXFLOAT, 30)];
    
    // 2定位单位标签
    CGRect rect = self.tempUnit.frame;
    rect.origin.x =  titleSize.width + CGRectGetMinX(self.temp.frame);
    self.tempUnit.frame = rect;
    
    self.SD.text = nowWeatherInfo.SD;
    self.WD.text = nowWeatherInfo.WD;
    self.WS.text = nowWeatherInfo.WS;
    
    self.time.text = nowWeatherInfo.time;
}

-(void)awakeFromNib
{
    // 背景音乐   背景音乐
    NSString *path  = [[NSBundle mainBundle]pathForResource:@"渔舟唱晚.mp3" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.aPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    self.aPlayer.delegate =self;
    // 音量
    self.aPlayer.volume = 0.4;
    // 循环次数
    self.aPlayer.numberOfLoops = 0;
}

#pragma mark  声音按钮点击事件
- (IBAction)voiceClick:(UIButton *)sender {
    // 判断只允许当前界面播放
    // isEndFlag == true 表示此view占用播放音乐资源
    if(isEndFlag == true)
    {
        // sender.tag == 1 此按钮是进入播放状态
        if(sender.tag == 1)
        {
            NSLog(@"tagL:%d",sender.tag);
            [self.aPlayer stop];   // 停止不是重新开始
            self.aPlayer.currentTime = 0;
            [_speekingVoice stopSpeekingVoice];
            isEndFlag =  false;
            [self.voice setBackgroundImage:[UIImage imageNamed:@"main_voice"] forState:UIControlStateNormal];
            [self.voice setBackgroundImage:[UIImage imageNamed:@"main_voice_pressed"] forState:UIControlStateHighlighted];
            // 置为 停止播放状态
            sender.tag = 0;
            return;
        }else
        {
          return;
        }
    }
    // 置为 正在播放状态
    sender.tag = 1;
    // 播放进行中
    isEndFlag = true;
    // 设置音乐播放按钮的播放状态背景图
    [self.voice setBackgroundImage:[UIImage imageNamed:@"broadcasting"] forState:UIControlStateNormal];
    [self.voice setBackgroundImage:[UIImage imageNamed:@"broadcasting_pressed"] forState:UIControlStateHighlighted];
    // 开始播放背景音乐
    [self.aPlayer prepareToPlay];
    [self.aPlayer play];
    
    // 播放天气信息
    NSMutableString *info = [NSMutableString stringWithString:@"您好,小天气为您播报，今天"];
    
    NSString *time =self.nowWeatherInfo.time;
    NSArray *timeArry = [time componentsSeparatedByString:@":"];
    int hour= [timeArry[0] intValue];
    if(hour>=6&&hour<=11)
    {
        [info appendFormat:@"早上"];
    }else if(hour>=12&&hour<=14)
    {
        [info appendFormat:@"中午"];
    }else if(hour>=15&&hour<=18)
    {
        [info appendFormat:@"下午"];
    }else
    {
        [info appendFormat:@"晚上"];
    }
    FutureWeekWeahterInfo *infoF = self.futureWeekWeahterInfo;
    NowWeatherInfo *infoF2 = self.nowWeatherInfo;
    
    [info appendFormat:@"%@发布,%@,今天白天到夜间，%@，温度，%@到%@摄氏度，湿度，%@，%@，风力,%@,",infoF2.time,infoF2.city,infoF.weather,infoF.temp_low,infoF.temp_high,infoF2.SD,infoF2.WD,infoF2.WS];
    
    
    _speekingVoice = [ZCNoneiFLYTEK shareManager];
    // 延迟2 秒播放
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_speekingVoice playVoice:info];
    });
    
}
#pragma mark 播放结束后执行的方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    // 播放结束
    isEndFlag = false;
    // 音乐播放按钮
    [self viewWithTag:1].tag = 0;
    // 设回音乐播放按钮背景图
    [self.voice setBackgroundImage:[UIImage imageNamed:@"main_voice"] forState:UIControlStateNormal];
    [self.voice setBackgroundImage:[UIImage imageNamed:@"main_voice_pressed"] forState:UIControlStateHighlighted];
}
#pragma mark 分享按钮点击事件
- (IBAction)shareClick:(UIButton *)sender {
    
    if([self.delegate respondsToSelector:@selector(weatherBriefViewShareBtnClickWithNowWeather: FutureWeekWeahterInfo:)])
    {
        [self.delegate weatherBriefViewShareBtnClickWithNowWeather:self.nowWeatherInfo FutureWeekWeahterInfo:self.futureWeekWeahterInfo];
    }
}
@end
