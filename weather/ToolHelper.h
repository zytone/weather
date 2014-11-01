//
//  ToolHelper.h
//  WeatherForecast
//
//  Created by ibokan on 14-10-27.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolHelper : NSObject

+(instancetype)toolHepler;

/**
 *  计算文字尺寸
 *
 *  @param text    被计算的文本
 *  @param font    字体
 *  @param maxSize 计算宽 CGSizeMake(MAXFLOAT, X) 计算高 CGSizeMake(X, MAXFLOAT)
 *
 */
-(CGSize)sizeWithText:(NSString*)text font:(UIFont*)font
              maxSize:(CGSize)maxSize;
@end
