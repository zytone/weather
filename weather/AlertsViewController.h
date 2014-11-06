//
//  AlertsViewController.h
//  weather
//
//  Created by YiTong.Zhang on 14-10-22.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertsViewController : UIViewController


@property(nonatomic,retain)NSMutableString *curLocationweatherInfo;
-(void)getCurrLocationWeatherInfo;
@end
