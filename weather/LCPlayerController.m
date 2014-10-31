//
//  LCPlayerController.m
//  WeatherForecast
//
//  Created by lrw on 14-10-21.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "LCPlayerController.h"



@interface LCPlayerController ()
@end

@implementation LCPlayerController

- (void)loadView
{
    [super loadView];
    
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc]init];
    
    /**  视频设置  **/
    MPMoviePlayerController *moviePlayer =player.moviePlayer;
    //重复播放
    moviePlayer.repeatMode = MPMovieRepeatModeOne;
    //满屏缩放
    moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    //隐藏工具栏，进度条
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    
    
    self.player = player;
    [self.view addSubview:player.view];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.movietType = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    MyLog(@"LCPlayerController销毁了...");
}

#pragma mark - setter
-(void)setMovietType:(LCMovieType)movietType
{
    if (movietType != _movietType) {//不一样才换视频
        _movietType = movietType;
        NSString *fileName = nil;
        /**  修改视频显示内容  **/
        switch (movietType) {
            case LCMovieTypeClear:
                fileName = @"clear";
                break;
            case LCMovieTypeN_Rain:
                fileName = @"n_rain";
                break;
            case LCMovieTypeOvercast:
                fileName = @"overcast";
                break;
            case LCMovieTypePartlycloudy:
                fileName = @"partlycloudy";
                break;
            case LCMovieTypeRain:
                fileName = @"rain";
                break;
            case LCMovieTypeSnow:
                fileName = @"snow";
                break;
            case LCMovieTypeWind:
                fileName = @"wind";
                break;
            default:
                break;
        }
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp4"];
        NSURL *url = [NSURL fileURLWithPath:path];
        self.player.moviePlayer.contentURL = url;
        [self.player.moviePlayer play];
    }
}
@end
