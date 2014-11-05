//
//  AGViewDelegate.m
//  ShareSDKForBackgroundOfNavigation
//
//  Created by lisa on 14-7-22.
//  Copyright (c) 2014年 lisa. All rights reserved.
//

#import "AGViewDelegate.h"
#import <AGCommon/UINavigationBar+Common.h>
#import "LCPlayerController.h"

@implementation AGViewDelegate

#pragma mark - ISSShareViewDelegate

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
        [[[(LCPlayerController *)_controller player] moviePlayer] pause];
    //修改分享界面和授权界面的导航栏背景
    UIImage *image = [UIImage imageNamed:@"background.jpg"];
    [viewController.navigationController.navigationBar setBackgroundImage:_image];
    //修改左右按钮的文字颜色
    UIBarButtonItem *leftBtn = viewController.navigationItem.leftBarButtonItem;
    UIBarButtonItem *rightBtn = viewController.navigationItem.rightBarButtonItem;
    [leftBtn setTintColor:[UIColor whiteColor]];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(click:) name:nil object:leftBtn];
    
    [rightBtn setTintColor:[UIColor whiteColor]];
    
    //修改标题颜色和文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.text = viewController.title;
    //label.text = @"哈哈";设置标题
    label.font = [UIFont boldSystemFontOfSize:16];
    [label sizeToFit];
    viewController.navigationItem.titleView = label;
}

-(void)viewOnCancelPublish:(UIViewController *)viewController
{
    [[[(LCPlayerController *)_controller player] moviePlayer] play];
}

- (void)click:(id)sender
{
    [[[(LCPlayerController *)_controller player] moviePlayer] play];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [[[(LCPlayerController *)_controller player] moviePlayer] play];
}

-(void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
