//
//  LRWDBHelper.m
//  SQLite
//
//  Created by lrw on 14-10-17.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "LRWDBHelper.h"
#import "NSObject+PropertyListing.h"

static sqlite3 *db = nil;//用static速度快

@implementation LRWDBHelper

/**
 *  打开数据库,资源包（Bundle）中数据，源文件只能读不能修改，要复制到资源包外面，沙盒里面才能修改（资源包在沙盒里面）
 */
+ (sqlite3 *)open
{
    /*
    NSDocumentationDirectory是linux下得文件，IOS没有
    NSDocumentDirectory是沙盒中的Documents文件夹
    path 的最终结果 就是获得 Documents目录下 Untitled.sqlite 的路径， 与下面savePath的值是一模一样的
    */
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    path = [path stringByAppendingPathComponent:@"cityname.sqlite"];
    
    
    //获得沙盒路径
    NSString *homePath = NSHomeDirectory();
    //获得Documents路径
    NSString *docPath = [homePath stringByAppendingPathComponent:@"Documents"];
    //文件路径
    NSString *path = [docPath stringByAppendingPathComponent:@"weather.sqlite"];
    
    if (db == nil){
        //资源包路径
        NSString *bunlePath = [[NSBundle mainBundle] pathForResource:@"weather.sqlite" ofType:nil];
        //文件管理器
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:path]) {//如果savePath路径的这个文件不存在
            //把资源包中 需要操作的文件 拷贝到 可以修改的文件路径下
            [fm copyItemAtPath:bunlePath toPath:path error:nil];
        }
    }
    
    /**
     *  [path UTF8String] OC 转 C
     */
    sqlite3_open([path UTF8String], &db);
    
    return db;
}

/**
 *  关闭数据库
 */
+ (void)close
{
    if (db != nil) {
        sqlite3_close(db);//sqlite3 会自动关闭
    }
}
#pragma mark - 增
+(BOOL)addDataToTable:(NSString *)aTableName example:(NSObject *)aExample
{
    /**
     *  sql语句合并
     */
    NSMutableString *sql = [NSMutableString stringWithFormat:@"insert into %@",aTableName];
    if (aExample != nil) {
        NSDictionary *propertiesDic = [aExample properties_aps];//属性-值
        NSMutableString *attributes = [NSMutableString string];//属性
        NSMutableString *values = [NSMutableString string];//插入值
        
        int index = 0;
        for (NSString *key in [propertiesDic allKeys]) {
            
            if ([key isEqualToString:@"ID"]) continue; //主键要自增，不需要插入
            
            if (index == 0)//第一个非ID属性
            {
                [attributes appendFormat:@"(%@",key];
                [values appendFormat:@"values('%@'",[propertiesDic valueForKey:key]];
                index++;
                continue;
            }
            else
            {
                [attributes appendFormat:@",%@",key];
                [values appendFormat:@",'%@'",[propertiesDic valueForKey:key]];
            }
        }
        
        [attributes appendString:@") "];
        [values appendString:@")"];
        [sql appendFormat:@"%@ %@",attributes,values];
    }
    
    /**
     *  向数据库 添加数据
     */
    sqlite3* db =  [self open];
    char *errormsg = NULL;
    BOOL result = YES;
    sqlite3_exec(db, [sql UTF8String],NULL, NULL, &errormsg);
    
    if (errormsg != NULL) {//添加失败
        NSLog(@"添加失败:%s",errormsg);
        result = NO;
    }
    
    [self close];
    return result;
}

#pragma mark - 删

+(BOOL)deleteDataFromTable:(NSString *)aTableName byID:(NSInteger)aID
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where ID=%d",aTableName,aID];
    
    /**
     *  删除记录
     */
    sqlite3* db =  [self open];
    char *errormsg = NULL;
    BOOL result = YES;
    sqlite3_exec(db, [sql UTF8String],NULL, NULL, &errormsg);
    
    if (errormsg != NULL) {//删除失败
        NSLog(@"删除失败:%s",errormsg);
        result = NO;
    }
    
    [self close];
    return result;
}

+(BOOL)deleteDataFromTable:(NSString *)aTableName byExample:(NSObject *)aExample
{
    /**
     *  合并sql语句
     */
    NSMutableString *sql = [NSMutableString stringWithFormat:@"delete from %@",aTableName];
    [self addConditionsWithSQL:sql example:aExample];
    
    
    
    /**
     *  删除记录
     */
    sqlite3* db =  [self open];
    char *errormsg = NULL;
    BOOL result = YES;
    sqlite3_exec(db, [sql UTF8String],NULL, NULL, &errormsg);
    
    if (errormsg != NULL) {//删除失败
        NSLog(@"删除失败:%s",errormsg);
        result = NO;
    }
    
    [self close];
    return result;
}

#pragma mark - 查

+(NSArray *)findDataFromTable:(NSString *)aTableName byExample:(NSObject *)aExample
{
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@",aTableName];
    //合并条件语句
    [self addConditionsWithSQL:sql example:aExample];
    
//    MyLog(@"%@",sql);
    
    NSMutableArray *dicArray = [NSMutableArray array];//记录所有记录的数组，一个记录用一个字典来存放
    sqlite3* db =  [self open];
    
    char *errormsg = NULL;
    sqlite3_exec(db, [sql UTF8String], dbCallBack, (__bridge void *)(dicArray), &errormsg);
    
    if (errormsg != NULL) {//查找失败
        NSLog(@"查找失败:%s sql:%@",errormsg,sql);
        [self close];
        return nil;
    }
    [self close];
    
    return dicArray;
}

+ (NSObject *)findDataFromTable:(NSString *)aTableName byID:(NSInteger)aID
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where ID=%d",aTableName,aID];
    
    sqlite3* db =  [self open];
    
    NSMutableArray *dicArray = [NSMutableArray array];//记录所有记录的数组，一个记录用一个字典来存放
    
    char *errormsg = NULL;
    sqlite3_exec(db, [sql UTF8String], dbCallBack, (__bridge void *)(dicArray), NULL);
    
    if (errormsg != NULL) {//查找失败
        NSLog(@"查找失败:%s",errormsg);
        [self close];
        return nil;
    }
    
    [self close];
    return [dicArray firstObject];
}

#pragma mark - 改

+(BOOL)updateOneDataFromTable:(NSString *)aTableName example:(NSObject *)aExample
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"update %@ set ",aTableName];
    if (aExample != nil) {
        NSDictionary *propertiesDic = [aExample properties_aps];//属性-值  字典
        NSMutableString *newValues = [NSMutableString string];//新值
        NSMutableString *conditions = [NSMutableString string];//条件
        
        int index = 0;
        for (NSString *key in [propertiesDic allKeys]) {
            
            //ID为空的时候
            if ([key isEqualToString:@"ID"] && [[propertiesDic valueForKey:key] intValue] == 0)
            {
                NSLog(@"ID为空,修改失败");
                return NO;
            }
            
            if ([key isEqualToString:@"ID"]) {//ID作为条件
                [conditions appendFormat:@" where ID = %@",[propertiesDic valueForKey:key]];
                continue;
            }
            
            if (index == 0)//第一个条件
            {
                [newValues appendFormat:@" %@ = '%@'",key,[propertiesDic valueForKey:key]];
                index++;
                continue;
            }
            [newValues appendFormat:@",%@ = '%@'",key,[propertiesDic valueForKey:key]];
        }
        [sql appendFormat:@"%@ %@",newValues,conditions];
    }
//    MyLog(@"%@",sql);
    /**
     *  修改记录
     */
    sqlite3* db =  [self open];
    char *errormsg = NULL;
    BOOL result = YES;
    sqlite3_exec(db, [sql UTF8String],NULL, NULL, &errormsg);
    
    if (errormsg != NULL) {//修改失败
        NSLog(@"修改失败:%s",errormsg);
        result = NO;
    }
    
    [self close];
    return result;
}

#pragma mark - all
/**
 *  每查到一条记录，就调用一次这个回调函数
 *  @param para        sqlite3_exec()传来的参数
 *  @param count       一条记录字段数
 *  @param char**value 是个关键值，查出来的数据都保存在这里，它实际上是个1维数组
 *  @param char**key   跟column_value是对应的，表示这个字段的字段名称
 */
int dbCallBack(void* para,int count ,char**value,char**key)
{
    NSMutableArray *dicArray = (__bridge NSMutableArray *)(para);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < count; i++) {
        [dic setObject:[NSString stringWithUTF8String:value[i] == nil ? "" : value[i]]
                forKey:[NSString stringWithUTF8String:key[i]]];
    }
    [dicArray addObject:dic];
    return 0;
}

#pragma mark 条件合拼
+ (void)addConditionsWithSQL:(NSMutableString *)aSQL example:(NSObject *)aExample
{
    if (aExample != nil) {
        NSDictionary *propertiesDic = [aExample properties_aps];//属性-值  字典
        NSMutableString *conditions = [NSMutableString string];//条件
        
        int index = 0;
        for (NSString *key in [propertiesDic allKeys]) {
            
            //ID为空的时候
            if ([key isEqualToString:@"ID"] && [[propertiesDic valueForKey:key] intValue] == 0) continue;
            
            if (index == 0)//第一个条件
            {
                [conditions appendFormat:@" where %@ like  '%%%@%%'",
                 key,[propertiesDic valueForKey:key]];
                index++;
                continue;
            }
            [conditions appendFormat:@" and %@ like  '%%%@%%'",
             key,[propertiesDic valueForKey:key]];
        }
        [aSQL appendString:conditions];
    }
}
@end