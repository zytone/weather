//
//  NSObject+PropertyListing.h
//  SQLite
//
//  Created by lrw on 14-10-18.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PropertyListing)
/**
 *  @return 返回对象所有  属性 ： 值
 */
- (NSDictionary *)properties_aps;

/**
 *  返回对象所有方法
 */
-(void)printMothList;
@end
