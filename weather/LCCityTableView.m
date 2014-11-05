//
//  LCCityTableView.m
//  weather
//
//  Created by lrw on 14/11/5.
//  Copyright (c) 2014年 lrw. All rights reserved.
//

#import "LCCityTableView.h"

@implementation LCCityTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 自定义拖动图标
 */
- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
//    if (editing) {
//        UIView *scrollView = self.subviews[0];
//        for (UIView * view in scrollView.subviews) {
//            MyLog(@"%@",[[[view.subviews[0] subviews] lastObject] subviews]);
//            UIImageView *image = [[[[view.subviews[0] subviews] lastObject] subviews] lastObject];
//            [image removeFromSuperview];
//        }
//    }
}

@end
