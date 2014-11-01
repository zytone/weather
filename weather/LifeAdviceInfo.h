//
//  LifeAdviceInfo.h
//  WeatherForecast
//
//  Created by ckx on 14-10-26.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LifeAdviceInfoItem.h"
@interface LifeAdviceInfo : NSObject
/**
 *  注：用于网络数据请求使用
 * （由于json数据中的所有生活指数只包含在一个字典中）数组存放 各种生活指数
 */
@property(nonatomic,retain)NSMutableArray *advsArry;

+(instancetype)lifeAdviceInfoWithDict:(NSDictionary*)dict;

-(instancetype)initLifeAdviceInfoWithDict:(NSDictionary*)dict;
@end
