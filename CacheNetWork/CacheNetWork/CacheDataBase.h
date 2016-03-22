//
//  CacheDataBase.h
//  CacheNetWork
//
//  Created by SZT on 16/3/22.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface CacheDataBase : NSObject

//打开数据库，如果没有该数据库的时候则创建
+ (sqlite3 *)open;


//关闭数据库 
+ (void)closeDataBase;

//往数据库里面添加字段 
+(void)insertDict:(NSDictionary *)dict WithMainKey:(NSString *)string;

@end
