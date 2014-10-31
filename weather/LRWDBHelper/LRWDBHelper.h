//
//  LRWDBHelper.h
//  SQLite
//
//  Created by lrw on 14-10-17.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface LRWDBHelper : NSObject
+ (sqlite3 *)open;
+ (void)close;
/**
 *  模糊查询
 *
 *  @param tableName 表名
 *  @param example   对象实例,(条件)<br>对象ID必须为int
 *
 *  @return 记录数组(字典数组)/没找到为nil
 */
+ (NSArray *)findDataFromTable:(NSString *)aTableName byExample:(NSObject *)aExample;

/**
 *  根据ID查找
 *
 *  @param aID 主键
 *  @param tableName 表名
 *
 *  @return 一条记录(字典)/没找到为nil
 */
+ (NSObject *)findDataFromTable:(NSString *)aTableName byID:(NSInteger)aID;

/**
 *  添加新记录
 *
 *  @param aTableName 表名
 *  @param aExample   实例对象（一条记录）
 *
 *  @return YES/NO 添加成功/添加失败
 */
+ (BOOL)addDataToTable:(NSString *)aTableName example:(NSObject *)aExample;

/**
 *  根据条件删除记录
 *
 *  @param aTableName 表名
 *  @param aExample   实例对象,(条件)<br>对象ID必须为int
 *
 *  @return YES/NO 删除成功/删除失败
 */
+ (BOOL)deleteDataFromTable:(NSString *)aTableName byExample:(NSObject *)aExample;

/**
 *  根据ID删除记录
 *
 *  @param aTableName 表名
 *  @param aID        主键
 *
 *  @return YES/NO 删除成功/删除失败
 */
+ (BOOL)deleteDataFromTable:(NSString *)aTableName byID:(NSInteger)aID;

/**
 *  跟新记录
 *
 *  @param aTableName 表名
 *  @param aExample   实例对象
 *
 *  @return YES/NO 跟新成功/跟新失败
 */
+ (BOOL)updateOneDataFromTable:(NSString *)aTableName example:(NSObject *)aExample;
@end
