//
//  LifeAdviceView.h
//  WeatherForecast
//
//  Created by ckx on 14-10-26.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LifeAdviceInfo.h"
#import "DetailSuperView.h"
// 代理协议
// 协议
@protocol LifeAdviceViewDelegate <NSObject>

@optional
-(void)lifeAdviceViewOnclick;
@end

@interface LifeAdviceView : DetailSuperView

+(instancetype)lifeAdviceViewWith:(CGRect) rect;
-(instancetype)initLifeAdviceViewWith:(CGRect) rect;
// 指数模型
@property(nonatomic,retain)NSArray *lifeAInfos;
// 代理
@property(nonatomic,strong)id<LifeAdviceViewDelegate> delegate;
@end
