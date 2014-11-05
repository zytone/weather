//
//  NumCompareViewController.h
//  weather
//
//  Created by YiTong.Zhang on 14/11/3.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NumCompareViewController : UIViewController

// nav 传过来的值  验证码
@property (nonatomic , copy)NSString *randomNum;

//  用户邮箱
@property (nonatomic, copy)NSString *mail;

@end
