//
//  AGViewDelegate.h
//  ShareSDKForBackgroundOfNavigation
//
//  Created by lisa on 14-7-22.
//  Copyright (c) 2014年 lisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ISSShareViewDelegate.h>

@interface AGViewDelegate : NSObject <ISSShareViewDelegate>
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) UIImage *image;
@end
