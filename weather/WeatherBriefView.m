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


@interface WeatherBriefView ()<AVAudioPlayerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *temp;
@property (weak, nonatomic) IBOutlet UILabel *tempUnit;
@property (weak, nonatomic) IBOutlet UILabel *SDLabel;

@property (weak, nonatomic) IBOutlet UILabel *SD;
@property (weak, nonatomic) IBOutlet UILabel *WD;
@property (weak, nonatomic) IBOutlet UILabel *WS;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

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

// 最下面的view
@property (weak, nonatomic) IBOutlet UIView *grayView;


@end
@implementation WeatherBriefView
@synthesize nowWeatherInfo = _nowWeatherInfo;
@synthesize futureWeekWeahterInfo =_futureWeekWeahterInfo;
+(instancetype)weatherBriefView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"WeatherBriefView" owner:nil options:nil]lastObject];
}

-(void)setFutureWeekWeahterInfo:(FutureWeekWeahterInfo *)futureWeekWeahterInfo
{
    _futureWeekWeahterInfo = futureWeekWeahterInfo;
    if(_futureWeekWeahterInfo != nil)
    {
        self.weatherLabel.text = _futureWeekWeahterInfo.weather;
        self.weatherImage.image = [UIImage imageNamed:_futureWeekWeahterInfo.weather_icon];
        self.dateLabel.text = _futureWeekWeahterInfo.days;
    }
}

-(void)setNowWeatherInfo:(NowWeatherInfo *)nowWeatherInfo
{
    _nowWeatherInfo = nowWeatherInfo;
    if(_nowWeatherInfo !=nil)
    {
        if (flagCityID == [nowWeatherInfo.cityid intValue]) {
            [self.voice setBackgroundImage:[UIImage imageNamed:@"broadcasting"] forState:UIControlStateNormal];
            [self.voice setBackgroundImage:[UIImage imageNamed:@"broadcasting_pressed"] forState:UIControlStateHighlighted];
        }
        else
        {
            [self.voice setBackgroundImage:[UIImage imageNamed:@"main_voice"] forState:UIControlStateNormal];
            [self.voice setBackgroundImage:[UIImage imageNamed:@"main_voice_pressed"] forState:UIControlStateHighlighted];
        }
        self.temp.text = nowWeatherInfo.temp;
        // 设置单位的位置紧靠temp
        // 1获取temp文字的宽度
        ToolHelper *tool = [ToolHelper toolHepler]; //工具类
        
        CGSize titleSize = [tool sizeWithText:self.temp.text font:self.temp.font maxSize:CGSizeMake(MAXFLOAT, 30)];
        
        // 2定位单位标签
        
        CGRect rect = self.tempUnit.frame;
        rect.origin.x =  titleSize.width + CGRectGetMinX(self.temp.frame);
        self.tempUnit.frame = rect;
        self.tempUnit.text = @"°C";
        self.SD.text = nowWeatherInfo.SD;
        self.SDLabel.text = @"湿度";
        self.WD.text = nowWeatherInfo.WD;
        self.WS.text = nowWeatherInfo.WS;
        
        if(nowWeatherInfo.time != nil)
        {
            NSMutableString *time = [NSMutableString stringWithString:@"今日 "];
            [time appendString:nowWeatherInfo.time];
            [time appendString:@" 发布"];
            self.time.text = time;
        }
    }else
    {
        // 隐藏分享和语音按钮
        self.shareBtn.hidden = YES;
        self.voice.hidden = YES;
        UILabel *label = [[UILabel alloc]initWithFrame:RECT(10, 10, 200, 50)];
        [label setFont:[UIFont systemFontOfSize:13]];
        label.text = @"抱歉，天气信息不可用";
        label.textColor = [UIColor whiteColor];
        [label setBackgroundColor:[UIColor clearColor]];
        [self.grayView addSubview:label];
    }
}

-(void)awakeFromNib
{
    // 背景音乐
    NSString *path  = [[NSBundle mainBundle]pathForResource:@"渔舟唱晚.mp3" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.aPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    self.aPlayer.delegate =self;
    // 音量
    self.aPlayer.volume = 0.4;
    // 循环次数
    self.aPlayer.numberOfLoops = 0;
}
// 声明和初始化整个程序使用的变量
extern bool isEndFlag = false;
extern NSString *flagCityID = nil;
#pragma mark  声音按钮点击事件
- (IBAction)voiceClick:(UIButton *)sender {
    
    // 保存播放当前的城市id
    flagCityID = self.nowWeatherInfo.cityid;
    // 判断只允许当前界面播放
    // isEndFlag == true 表示此view占用播放音乐资源
    if(isEndFlag == true)
    {
        // sender.tag == 1 此按钮是进入播放状态
        if(sender.tag == 1)
        {
            // 置为 停止播放状态
        
            sender.tag = 0;
            flagCityID = nil;
            // 取消资源占用
            isEndFlag =  false;
            [self.voice setBackgroundImage:[UIImage imageNamed:@"main_voice"] forState:UIControlStateNormal];
            [self.voice setBackgroundImage:[UIImage imageNamed:@"main_voice_pressed"] forState:UIControlStateHighlighted];
            
            [self.aPlayer stop];   // 停止不是重新开始
            self.aPlayer.currentTime = 0;
            [_speekingVoice stopSpeekingVoice];
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
    if([flagCityID isEqualToString:self.nowWeatherInfo.cityid])
    {
     [self.voice setBackgroundImage:[UIImage imageNamed:@"broadcasting"] forState:UIControlStateNormal];
     [self.voice setBackgroundImage:[UIImage imageNamed:@"broadcasting_pressed"] forState:UIControlStateHighlighted];
        
    }
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

    [info appendFormat:@"%@发布,%@,",infoF2.time,infoF2.city];
    if(infoF !=nil)
    {
      [info appendFormat:@"今天白天到夜间，%@，温度，%@到%@摄氏度，",infoF.weather,infoF.temp_low,infoF.temp_high];
    }else
    {
        [info appendFormat:@"温度，%@摄氏度",infoF2.temp];
    }
    
    [info appendFormat:@",湿度，%@，%@，风力,%@,",infoF2.SD,infoF2.WD,infoF2.WS];
    
    
    
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
    NSLog(@"asfsdf");
    // 设回音乐播放按钮背景图
    [self.voice setBackgroundImage:[UIImage imageNamed:@"main_voice"] forState:UIControlStateNormal];
    [self.voice setBackgroundImage:[UIImage imageNamed:@"main_voice_pressed"] forState:UIControlStateHighlighted];
    flagCityID = nil;
}
#pragma mark 分享按钮点击事件
- (IBAction)shareClick:(UIButton *)sender {
    
    if([self.delegate respondsToSelector:@selector(weatherBriefViewShareBtnClickWithNowWeather: FutureWeekWeahterInfo:)])
    {
        [self.delegate weatherBriefViewShareBtnClickWithNowWeather:self.nowWeatherInfo FutureWeekWeahterInfo:self.futureWeekWeahterInfo];
    }
}
@end
