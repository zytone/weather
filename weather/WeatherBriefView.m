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
{
    UILabel *tipErrorLabel;
}


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

@property (weak, nonatomic) IBOutlet UIView *bottomGrayView;

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
    }else
    {
        self.weatherLabel.text = @"";
        self.weatherImage.image = nil;
        self.dateLabel.text = @"";
    }
}

-(void)setNowWeatherInfo:(NowWeatherInfo *)nowWeatherInfo
{
    _nowWeatherInfo = nowWeatherInfo;
    if(_nowWeatherInfo !=nil)
    {
        // 隐藏除了数据请求为空的label 的所有button和label  预防网络数据刷新后。。  // 考虑清空 （暂定）
        self.shareBtn.hidden = NO;
        self.voice.hidden = NO;
        self.weatherImage.hidden = NO;
        self.weatherLabel.hidden = NO;
        self.dateLabel.hidden = NO;
        self.tempUnit.hidden = NO;
        self.SD.hidden = NO;
        self.SDLabel.hidden = NO;
        self.WD.hidden = NO;
        self.WS.hidden = NO;
        tipErrorLabel.hidden = YES;
        self.temp.hidden = NO;
        self.time.hidden = NO;

        // 控制播音按钮btn的状态
        if ([flagCityID isEqualToString:_nowWeatherInfo.cityid])
        {
            [self.voice setBackgroundImage:[UIImage imageNamed:@"broadcasting"] forState:UIControlStateNormal];
            [self.voice setBackgroundImage:[UIImage imageNamed:@"broadcasting_pressed"] forState:UIControlStateHighlighted];
        }
        else
        {
            [self.voice setBackgroundImage:[UIImage imageNamed:@"main_voice"] forState:UIControlStateNormal];
            [self.voice setBackgroundImage:[UIImage imageNamed:@"main_voice_pressed"] forState:UIControlStateHighlighted];
        }
        
        // 温度label
        self.temp.text = nowWeatherInfo.temp;
        // 温度单位
        // 设置单位的位置紧靠temp
        // 1获取temp文字的宽度
        ToolHelper *tool = [ToolHelper toolHepler]; //工具类
        CGSize titleSize = [tool sizeWithText:self.temp.text font:self.temp.font maxSize:CGSizeMake(MAXFLOAT, 30)];
        CGRect rect = self.tempUnit.frame;
        rect.origin.x =  titleSize.width + CGRectGetMinX(self.temp.frame);
        self.tempUnit.frame = rect;
        self.tempUnit.text = @"°C";
        // 湿度 风力 方向 label
        self.SD.text = nowWeatherInfo.SD;
        self.SDLabel.text = @"湿度";
        self.WD.text = nowWeatherInfo.WD;
        self.WS.text = nowWeatherInfo.WS;

        // 发布时间 label
        NSMutableString *time = [NSMutableString stringWithString:@"今日 "];
        [time appendString:nowWeatherInfo.time];
        [time appendString:@" 发布"];
        self.time.text = time;
    }else
    {
        // 隐藏分享和语音按钮
        self.shareBtn.hidden = YES;
        self.voice.hidden = YES;
        self.weatherImage.hidden = YES;
        self.weatherLabel.hidden = YES;
        self.dateLabel.hidden = YES;
        self.tempUnit.hidden = YES;
        self.SD.hidden = YES;
        self.SDLabel.hidden = YES;
        self.WD.hidden = YES;
        self.WS.hidden = YES;
        self.temp.hidden = YES;
        self.time.hidden = YES;
        tipErrorLabel.hidden = NO;
    }
}
#pragma mark - 初始化 背景音乐播放器
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
 
    // 错误提示
    tipErrorLabel = [[UILabel alloc]initWithFrame:RECT(10, 10, 200, 50)];
    // 先隐藏
    tipErrorLabel.hidden = YES;
    [tipErrorLabel setFont:[UIFont systemFontOfSize:13]];
    tipErrorLabel.text = @"抱歉，天气信息不可用";
    tipErrorLabel.textColor = [UIColor whiteColor];
    [tipErrorLabel setBackgroundColor:[UIColor clearColor]];
    [self.grayView addSubview:tipErrorLabel];
    
    // 最下面两个view
    self.grayView.layer.cornerRadius = 10;
    self.bottomGrayView.layer.cornerRadius = 10;
}

// 声明和初始化整个程序使用的变量
extern bool isEndFlag = false;      // 标识是否当前view是否在播放音乐
extern NSString *flagCityID = nil;  // 标识是否播放当前的城市天气信息，以控制另个重用的view得播放音乐按钮状态

#pragma mark  声音按钮点击事件
- (IBAction)voiceClick:(UIButton *)sender {
    
    
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
            
            
            // 停止播放
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
    
    // 播放天气信息准备
    NSMutableString *info = [NSMutableString stringWithString:@"，，，，，您好,小天气为您播报，今天"];
    
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
 
    // 开始播放背景音乐
    [self.aPlayer prepareToPlay];
    [self.aPlayer play];
      // 开始播放语音
    [_speekingVoice playVoice:info];
  
    // 保存播放当前的城市id
    flagCityID = self.nowWeatherInfo.cityid;
    
    // 控制播音按钮btn的状态 为播音状态
    [self.voice setBackgroundImage:[UIImage imageNamed:@"broadcasting"] forState:UIControlStateNormal];
    [self.voice setBackgroundImage:[UIImage imageNamed:@"broadcasting_pressed"] forState:UIControlStateHighlighted];
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
