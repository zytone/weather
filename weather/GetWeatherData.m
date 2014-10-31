//
//  GetNowWeatherData.m
//  PushChat
//
//  Created by YiTong.Zhang on 14-10-27.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import "GetWeatherData.h"

@interface GetWeatherData () <NSURLConnectionDataDelegate>
{
    NSDictionary *dic;
    DATATYPE _type;   // 请求的数据种类 3 种
}

// 接收在传输过程中的数据段，以拼接的方式
@property (nonatomic,strong)NSMutableData *requestData;

@end
/**
 *  网络请求当天天气数据的类，只需要创建一个对象，然后传入要查找的城市的编号，再设置代理，实现代理方法，即可获得对应城市气象数据
 */
@implementation GetWeatherData
/**
 *  用block来实现
 *
 */
- (void) getWeatherDataByStrUrl : (NSString * )urlStr
{
    // 1、创建一个链接的字符串
    //    NSString *urlStr = [NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html",cityNum];
    
    // 2、创建一个url
    NSURL *url = [NSURL URLWithString:urlStr];
    // 3、创建一个请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // 访问超时
    request.timeoutInterval = 5.0f;
    // 4、发送请求    使用block实现
    
    // 创建一个主队列
    NSOperationQueue *queu = [NSOperationQueue mainQueue];
    
    // 不稳定，偶尔会请求超时
    [NSURLConnection sendAsynchronousRequest:request queue:queu completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // 获取数据转换为字典
        NSMutableDictionary *mDic;
        if (!data)
        {
            mDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }
        NSDictionary *dicData = mDic[@"weatherinfo"];
        [self.delegate getNowWeatherData:dicData errorMessage:connectionError];
    }];
}
//
-(void)getData:(NSString *)urlStr Type:(DATATYPE)type
{
    _type =type;
    [self getWeatherDataByUrlString:urlStr];
}

/**
 *  使用代理来实现异步请求数据
 *
 */
- (void) getWeatherDataByUrlString : (NSString * )urlStr
{
    
    // 2、创建一个url
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 3、创建一个请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // 访问超时
    request.timeoutInterval = 5.0f;
    
    // 4、发送请求    使用代理来发送异步请求
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //发送请求
    [connection start];
}

- (instancetype) initWithUrlStr: (NSString *)urlStr Type:(DATATYPE)type
{
    if (self = [super init]) {
        // 1、代理实现
        [self getWeatherDataByUrlString:urlStr];
        // 2、block实现
//        [self getWeatherDataByStrUrl:urlStr];
  
        
        _type = type;
    }
    return self;
}

+ (instancetype) getWeatherData: (NSString *)urlStr Type:(DATATYPE)type
{
         
    return [[self alloc] initWithUrlStr:urlStr Type:type];
}

#pragma mark - 获取数据  json
/**
 *  解析json数据,当前天气数据数据
 *
 */
- (NSMutableDictionary *) getJsonWithURL:(NSData *) data
{
    NSMutableDictionary *mDic ;
    
    if (data != nil) {
        mDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
    return mDic;
}

#pragma mark - 网络请求代理

/**
 *  当接收到服务器的响应 （连上服务器），就会被调用
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _requestData = [NSMutableData data];
}

/**
 *  当接收到服务器数据的时候会被调用，会被调用多次 （每次接收的数据都是一部分）
 *
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 拼接每次获取的数据
    [_requestData appendData:data];
}
/**
 *  当数据加载完的时候调用
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 获得数据
    NSDictionary *dicData = [self getJsonWithURL:self.requestData];
    // 将数据传给代理
    if(_type == NOWWEATHER)
    {
        if([self.delegate respondsToSelector:@selector(getNowWeatherData: errorMessage:)])
        {
           [self.delegate getNowWeatherData:dicData errorMessage:nil];
        }
    }else
        if(_type == WEEKWEATHER)
    {
        if([self.delegate respondsToSelector:@selector(getWeekWeatherData: errorMessage:)])
        {
            [self.delegate getWeekWeatherData:dicData errorMessage:nil];
        }
    }else if(_type == LIFEADVICE)
    {
        if([self.delegate respondsToSelector:@selector(getLifeAdviceData: errorMessage:)])
        {
            [self.delegate getLifeAdviceData:dicData errorMessage:nil];
        }
    }else
    {
        NSLog(@"there is not _type data");
    }
}
/**
 *  当数据加载失败的时候
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // 加载数据失败
    // 将空数据传给代理
    if(_type == NOWWEATHER)
    {
        if([self.delegate respondsToSelector:@selector(getNowWeatherData: errorMessage:)])
        {
            [self.delegate getNowWeatherData:nil errorMessage:error];
        }
    }else
        if(_type == WEEKWEATHER)
        {
            if([self.delegate respondsToSelector:@selector(getWeekWeatherData: errorMessage:)])
            {
                [self.delegate getWeekWeatherData:nil errorMessage:error];
            }
        }else if(_type == LIFEADVICE)
        {
            if([self.delegate respondsToSelector:@selector(getLifeAdviceData: errorMessage:)])
            {
                [self.delegate getLifeAdviceData:nil errorMessage:error];
            }
        }else
        {
            NSLog(@"网络数据请求失败！");
        }
}


@end
