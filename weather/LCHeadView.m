//
//  LCHeadView.m
//  WeatherForecast
//
//  Created by lrw on 14-10-23.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "LCHeadView.h"
/**
 *  button tag
 */
#define LEFTBTN 1000
#define RIGHTBTN 1001


@interface LCHeadView ()
@property (nonatomic , weak) UIView *separate;
@property (nonatomic , weak) CALayer *backgroundLayer;
@property (nonatomic , weak) UIButton *leftBtn;
@property (nonatomic , weak) UIButton *rightBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic , weak) UIImageView *loading;
@end
@implementation LCHeadView

- (instancetype)init
{
    if (self = [super init])
    {
        //分隔线
        UIView *separate = [[UIView alloc]init];
        separate.backgroundColor = [UIColor blackColor];
        separate.alpha = 0.3;
        self.separate = separate;
//        [self addSubview:separate];
        
        //阴影
        CALayer *backgroundLayer = [CALayer layer];
        backgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
        backgroundLayer.opacity = 0.4;
        backgroundLayer.cornerRadius = 5;
        backgroundLayer.masksToBounds = YES;
        self.backgroundLayer = backgroundLayer;
        [self.layer addSublayer:backgroundLayer];
        
        //标题
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
//        label.text = @"哈尔滨";
        self.titleLabel = label;
        [self addSubview:label];
        
        //左边按钮
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.tag = LEFTBTN;
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"dock-more"] forState:UIControlStateNormal];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"dock-more-highlighted"] forState:UIControlStateHighlighted];
        [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn = leftBtn;
        [self addSubview:leftBtn];
        
        //右边按钮
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.tag = RIGHTBTN;
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"dock-city"] forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"dock-city-highlighted"] forState:UIControlStateHighlighted];
        [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.rightBtn = rightBtn;
        [self addSubview:rightBtn];
        
        //加载图片
        UIImageView *loadingImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading"]];
        self.loading = loadingImage;
        [self addSubview:loadingImage];
    }
    return self;
}

- (void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(headViewDelegate:button:)]) {
        if (btn.tag == LEFTBTN) [self.delegate headViewDelegate:self button:LCHeadButton_Left];
        else [self.delegate headViewDelegate:self button:LCHeadButton_Right];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    //按钮位置
    CGFloat btnH = self.height * 0.5;
    CGFloat btnW = btnH;
    CGFloat btnY = self.height * 0.5;
    self.leftBtn.frame = RECT(0, btnY , btnW, btnH);
    self.rightBtn.frame = RECT(self.width - btnW, btnY , btnW, btnH);
    
    //title 位置
    CGFloat titleX = btnW;
    CGFloat titleY = btnY;
    CGFloat titleW = self.width - 2 * titleX;
    CGFloat titleH = self.height - titleY;
    self.titleLabel.frame = RECT(titleX, titleY,titleW ,titleH);
    
    //阴影位置
    self.backgroundLayer.frame = self.bounds;
    
    //分隔线位置
    self.separate.frame = RECT(0, self.height * 0.5 , self.width , 1);
    
    //刷新
    self.loading.frame = RECT(0, 0, 30, 30);
    self.loading.center = POINT(self.width * 0.5, self.height * 0.25);
}

-(void)beginLoading
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.delegate = self;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 1.0)];
    animation.duration = 0.6;
    animation.cumulative = YES;
    animation.repeatCount = INT_MAX;
    
    [self.loading.layer addAnimation:animation forKey:@"animation"];
}

-(void)endLoading
{
    
}

@end
