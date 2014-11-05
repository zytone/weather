//
//  DetailSuperView.m
//  WeatherForecast
//
//  Created by ibokan on 14-10-28.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "DetailSuperView.h"

@implementation DetailSuperView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        // 标题
        _titleLabel = [[UILabel alloc]initWithFrame:RECT(20, 5, frame.size.width-20, TitleHeight -10)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:TitleFontSize];
        [self addSubview:_titleLabel];
        
        // 白色行线
        _whiteLine = [[UIView alloc]initWithFrame:RECT(10, 45, frame.size.width-20, 1)];
        _whiteLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:_whiteLine];
        
        CALayer *layer = [CALayer layer];
        layer.cornerRadius = 10;
        layer.masksToBounds = YES;
        layer.frame = self.bounds;
        layer.backgroundColor = [UIColor blackColor].CGColor;
        layer.opacity = 0.03;
        [self.layer addSublayer:layer];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark view中的阴影设置
//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    CALayer *layer = [CALayer layer];
//    layer.cornerRadius = 10;
//    layer.masksToBounds = YES;
//    layer.frame = self.bounds;
//    layer.backgroundColor = [UIColor blackColor].CGColor;
//    layer.opacity = 0.03;
//    [self.layer addSublayer:layer];
//}
@end
