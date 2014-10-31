//
//  LCHeadView.h
//  WeatherForecast
//
//  Created by lrw on 14-10-23.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <UIKit/UIKit.h>
enum {
    LCHeadButton_Left,
    LCHeadButton_Right
};
typedef NSInteger LCHeadButton;

@protocol LCHeadViewDelegate;

@interface LCHeadView : UIView
@property (nonatomic , weak) UILabel *titleLabel;
@property (nonatomic , weak) id<LCHeadViewDelegate> delegate;
-(void)beginLoading;
-(void)endLoading;
@end

@protocol LCHeadViewDelegate <NSObject>
@optional
- (void)headViewDelegate:(LCHeadView *)headView button:(LCHeadButton )button;
@end
