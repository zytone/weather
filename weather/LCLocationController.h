//
//  LCLocationController.h
//  WeatherForecast
//
//  Created by lrw on 14-10-27.
//  Copyright (c) 2014年 LRW. All rights reserved.
//  获取当前位置

#import <UIKit/UIKit.h>
typedef void (^LCLocationResult)(NSString *cityName, NSError *error);
@protocol LCLocationControllerDelegate;

@interface LCLocationController : UIViewController
@property (nonatomic , weak) id<LCLocationControllerDelegate> delegate;
@property (nonatomic, copy) NSString *cityName;

- (void)update;
@end

@protocol LCLocationControllerDelegate <NSObject>
@optional
- (void)locationController:(LCLocationController *)locationController result:(NSDictionary *)result;
@end
