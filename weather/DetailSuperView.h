//
//  DetailSuperView.h
//  WeatherForecast
//
//  Created by ibokan on 14-10-28.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TitleHeight 50   // 标题高度
#define TitleFontSize 16 // 标题的字体大小
#define ContentFontSize 13      // 内容字体大小

@interface DetailSuperView : UIView
// 标题
@property(nonatomic,retain)UILabel *titleLabel;
@end
