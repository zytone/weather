//
//  LCBackgroundView.m
//  WeatherForecast
//
//  Created by lrw on 14-10-23.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "LCBackgroundView.h"
@interface LCBackgroundView ()
@property (nonatomic , weak) CALayer *shadow;
@end
@implementation LCBackgroundView

-(id)init
{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        CALayer *layer = [CALayer layer];
        self.shadow = layer;
        layer.cornerRadius = 10;
        layer.masksToBounds = YES;
        layer.backgroundColor = [UIColor blackColor].CGColor;
        layer.opacity = 0.25;
        [self.layer addSublayer:layer];

    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.shadow.frame = self.bounds;

}

@end
