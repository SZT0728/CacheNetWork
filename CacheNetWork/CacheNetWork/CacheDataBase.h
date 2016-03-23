//
//  CacheDataBase.h
//  CacheNetWork
//
//  Created by SZT on 16/3/22.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

//该类是数据库类，用来对数据进行沙盒存储的
@interface CacheDataBase : NSObject

//创建数据库，如果数据库存在的话则打开数据库
+ (sqlite3 *)open;

//关闭数据库 
+ (void)closeDataBase;

//根据url将数据缓存进沙盒中
+(void)insertDict:(NSDictionary *)dict WithMainKey:(NSString *)string;

// 根据url将缓存在沙盒中的数据读取出来
+ (NSDictionary *)selectDictWithUrlString:(NSString *)urlString;

//根据url删除沙盒数据缓存
+(void)deleteDictWithUrlString:(NSString *)Urlstring;

//清除沙盒缓存
+ (void)deleteAllData;

@end
