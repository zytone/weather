//
//  LifeAdviceInfo.m
//  WeatherForecast
//
//  Created by ckx on 14-10-26.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "LifeAdviceInfo.h"

@implementation LifeAdviceInfo

+(instancetype)lifeAdviceInfoWithDict:(NSDictionary*)dict
{
    return [[LifeAdviceInfo alloc]initLifeAdviceInfoWithDict:dict];
}

-(instancetype)initLifeAdviceInfoWithDict:(NSDictionary*)dict
{
    if(self = [super init])
    {
        
        /**
         *  1 晨练指数 cl_name,cl_hint,cl_des
         */
        LifeAdviceInfoItem *item1 = [[LifeAdviceInfoItem alloc]init];
        item1.cityid = dict[@"cityid"];
        item1.date = dict[@"date"];
        item1.name = dict[@"cl_name"];
        item1.hint = dict[@"cl_hint"];
        item1.des= dict[@"cl_des"];
        /**
         *  2 穿衣指数 ct_name,ct_hint,ct_des
         */
        LifeAdviceInfoItem *item2 = [[LifeAdviceInfoItem alloc]init];
        item2.cityid = dict[@"cityid"];
        item2.date = dict[@"date"];
        item2.name = dict[@"ct_name"];
        item2.hint = dict[@"ct_hint"];
        item2.des = dict[@"ct_des"];
        
        /**
         *  3 钓鱼指数 dy_name,dy_hint,dy_des
         */
        LifeAdviceInfoItem *item3 = [[LifeAdviceInfoItem alloc]init];
        item3.cityid = dict[@"cityid"];
        item3.date = dict[@"date"];
        item3.name = dict[@"dy_name"];
        item3.hint = dict[@"dy_hint"];
        item3.des = dict[@"dy_des"];
        /**
         *  4 防晒指数 fs_name,fs_hint,fs_des
         */
        LifeAdviceInfoItem *item4 = [[LifeAdviceInfoItem alloc]init];
        item4.cityid = dict[@"cityid"];
        item4.date = dict[@"date"];
        item4.name = dict[@"fs_name"];
        item4.hint = dict[@"fs_hint"];
        item4.des = dict[@"fs_des"];
      
        /**
         *  5 感冒指数 gm_name,gm_hint,gm_des
         */
        LifeAdviceInfoItem *item5 = [[LifeAdviceInfoItem alloc]init];
        item5.cityid = dict[@"cityid"];
        item5.date = dict[@"date"];
        item5.name = dict[@"gm_name"];
        item5.hint = dict[@"gm_hint"];
        item5.des = dict[@"gm_des"];

        /**
         *  6 旅游指数 tr_name,tr_hint,tr_res
         */
        LifeAdviceInfoItem *item6 = [[LifeAdviceInfoItem alloc]init];
        item6.cityid = dict[@"cityid"];
        item6.date = dict[@"date"];
        item6.name = dict[@"tr_name"];
        item6.hint = dict[@"tr_hint"];
        item6.des = dict[@"tr_des"];

        // 存放入数组中
        self.advsArry =[NSMutableArray arrayWithObjects:item1,item2,item3,item4,item5,item6,nil];
    }
    return  self;
}
@end
