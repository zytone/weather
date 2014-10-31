//
//  GetNowWeatherData.h
//  PushChat
//
//  Created by YiTong.Zhang on 14-10-27.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    NOWWEATHER = 0,
    WEEKWEATHER = 1,
    LIFEADVICE = 2,
}DATATYPE;

// 协议
@protocol GetWeatherDataDelegate <NSObject>

@optional

// 代理获取链接后的数据和状态
// 获取实现天气信息
- (void) getNowWeatherData:(NSDictionary *)dic errorMessage:(NSError *)err;
// 获取一周的天气信息
- (void) getWeekWeatherData:(NSDictionary *)dic errorMessage:(NSError *)err;
// 获取生活建议信息
- (void) getLifeAdviceData:(NSDictionary *)dic errorMessage:(NSError *)err;
@end

// 声明
@interface GetWeatherData : NSObject

// 设置代理
@property (nonatomic, strong) id<GetWeatherDataDelegate> delegate;


// 初始化数据
- (instancetype) initWithUrlStr: (NSString *)urlStr Type:(DATATYPE)type;
// 便利构造器
+ (instancetype) getWeatherData: (NSString *)urlStr Type:(DATATYPE)type;

// 直接获取
-(void)getData:(NSString *)urlStr Type:(DATATYPE)type;

@end
