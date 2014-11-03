//
//  LCWeatherDetailsController.h
//  WeatherForecast
//
//  Created by lrw on 14-10-21.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCHeadView.h"
/**
 *  刷新距离
 */
#define REFRESHHEIGHT 44

#define VIEWPADDING 10

@protocol LCWeatherDetailsControllerDelegate;
@class NowWeatherInfo,FutureWeekWeahterInfo;
@interface LCWeatherDetailsController : UIViewController
@property (nonatomic , weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *topTitle;
@property (nonatomic, copy) NSString *city_num;
/**
 *  刷新View和ItemView结合
 */
@property (nonatomic , weak) LCHeadView *headView;
@property (nonatomic , weak) id<LCWeatherDetailsControllerDelegate> delegate;

/**
 *  获取背景视频名称.MP4
 */
-(int)getBackGroudVedioName;

@end

@protocol LCWeatherDetailsControllerDelegate <NSObject>
@optional
- (void)weatherDetailsController:(LCWeatherDetailsController *)controller scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)weatherDetailsController:(LCWeatherDetailsController *)controller scrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)weatherDetailsController:(LCWeatherDetailsController *)controller scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)weatherDetailsController:(LCWeatherDetailsController *)controller showRefresh:(UIView *)headView;
- (void)weatherDetailsController:(LCWeatherDetailsController *)controller scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)weatherDetailsController:(LCWeatherDetailsController *)controller topBtnClick:(LCHeadButton )lcButton;
- (void)weatherDetailsControllerShareBtnClick:(LCWeatherDetailsController *)controller NowWeather:(NowWeatherInfo *)nowInfo FutureWeekWeahterInfo:(FutureWeekWeahterInfo *)nowFutureInfo;

//-----------
-(void)weatherDetailsController:(LCWeatherDetailsController *)controller headView:(LCHeadView *)headView;
//-----------
@end
