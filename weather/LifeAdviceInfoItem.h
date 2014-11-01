//
//  LifeAdviceInfoItem.h
//  WeatherForecast
//
//  Created by ckx on 14-10-26.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LifeAdviceInfoItem : NSObject
// ID
@property(nonatomic,assign)int ID;
// 城市id
@property(nonatomic,retain) NSString *cityid;
// 日期
@property(nonatomic,retain) NSString *date;

// 指数名称
@property(nonatomic,retain) NSString *name;
// 指数程度
@property(nonatomic,retain) NSString *hint;
// 指数描述
@property(nonatomic,retain) NSString *des;


// 插入操作
-(void)insertLifeAdviceInfoItem:(LifeAdviceInfoItem*)info;
//根据cityid 和date 日期查这个城市的所有生活指数
+(NSArray *)searchLifeAdviceInfoItemsByCityId:(NSString*)cityid Date:(NSString*)date;
@end
