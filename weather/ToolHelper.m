//
//  ToolHelper.m
//  WeatherForecast
//
//  Created by ibokan on 14-10-27.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "ToolHelper.h"

@implementation ToolHelper
+(instancetype)toolHepler
{
    return [[ToolHelper alloc]init];
}
/**
 *  计算文字尺寸
 */
-(CGSize)sizeWithText:(NSString*)text font:(UIFont*)font
              maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:attrs context:nil].size;
}
@end
