//
//  LCPlayerController.h
//  WeatherForecast
//
//  Created by lrw on 14-10-21.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
enum {
    LCMovieTypeClear,
    LCMovieTypeN_Rain,
    LCMovieTypeOvercast,
    LCMovieTypePartlycloudy,
    LCMovieTypeRain,
    LCMovieTypeSnow,
    LCMovieTypeWind
};
typedef NSInteger LCMovieType;
@class MPMoviePlayerViewController;
@interface LCPlayerController : UIViewController

/**
 *  视频内容，天气类型
 */
@property (nonatomic, assign) LCMovieType movietType;
/**
 *  视屏控制器
 */
@property (nonatomic , strong) MPMoviePlayerViewController *player;
@end
