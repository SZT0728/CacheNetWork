//
//  CacheDataBase.m
//  CacheNetWork
//
//  Created by SZT on 16/3/22.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "CacheDataBase.h"
#import "DataTransfer.h"

#define dataBaseName  @"CacheDataBase.sqlite"


@implementation CacheDataBase

static sqlite3 *dataBase = nil;

+ (sqlite3 *)open
{
    @synchronized(self) {
        
        if (dataBase == nil) {
            NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString *dataBasePath = [docPath stringByAppendingPathComponent:dataBaseName];
            NSLog(@"数据库路径-------%@",dataBasePath);
            int result = sqlite3_open(dataBasePath.UTF8String, &dataBase);
            if (result == SQLITE_OK) {
                NSLog(@"数据库打开成功");
                NSString *creatSQL = @"create table 'Cache' (uid text primary key not null,dict blob);";
                
                int result2 = sqlite3_exec(dataBase, creatSQL.UTF8String, nil, nil, nil);
                if (result2 == SQLITE_OK) {
                    NSLog(@"数据库创建表创建成功");
                }else{
                    NSLog(@"数据库创建表失败");
                }
            }
            
        }
        
    }
    return dataBase;
}

+ (void)closeDataBase
{
    sqlite3_close(dataBase);
}



+(void)insertDict:(NSDictionary *)dict WithMainKey:(NSString *)string
{
    sqlite3 *dB = [self open];
    NSString *sql = [NSString stringWithFormat:@"insert into 'Cache' values('%@',?);",string];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(dB, sql.UTF8String, -1, &stmt, nil);

    if (result == SQLITE_OK) {
        NSLog(@"插入语句可以使用");
        //将字典转化了data类型之后绑定
        NSMutableData *data = [DataTransfer dataFromDict:dict];
        sqlite3_bind_blob(stmt, 1, [data bytes], (int)data.length, nil);
        
        sqlite3_step(stmt);
    }else{
        NSLog(@"插入语句不可用");
    }
    sqlite3_finalize(stmt);
    
}

+ (NSDictionary *)selectDictWithUrlString:(NSString *)urlString
{
    NSDictionary *dict;
    sqlite3 *dB = [self open];
    NSString *sql = [NSString stringWithFormat:@"select * from 'Cache' where uid = '%@';",urlString];
    int result = sqlite3_exec(dB, sql.UTF8String, nil, nil, nil);
    if (result == SQLITE_OK) {
        NSLog(@"select1 == ok");
        sqlite3_stmt *stmt = nil;
        int result1 = sqlite3_prepare_v2(dB, sql.UTF8String, -1, &stmt, nil);
        if (result1 == SQLITE_OK) {
            NSLog(@"select2 == ok");
            sqlite3_step(stmt);
            NSData *data = [NSData dataWithBytes:sqlite3_column_blob(stmt, 1) length:sqlite3_column_bytes(stmt, 1)];
            dict = [DataTransfer dictFromData:data];
        }else{
            NSLog(@"select2 == error");
        }
    }else{
        NSLog(@"select1 == error");
    }
    return dict;
}

+(void)deleteDictWithUrlString:(NSString *)Urlstring
{
    sqlite3 *db = [self open];
    NSString *sql = [NSString stringWithFormat:@"delete from 'Cache' where uid = '%@';",Urlstring];
    int result = sqlite3_exec(db, sql.UTF8String, nil, nil, nil);
    if (result == SQLITE_OK) {
        NSLog(@"删除成功");
    }
}

+ (void)deleteAllData
{
    sqlite3 *dB = [self open];
    NSString *sql = @"delete from 'Cache';";
    int result = sqlite3_exec(dB, sql.UTF8String, nil, nil, nil);
    if (result == SQLITE_OK) {
        NSLog(@"数据表全部删除");
    }
}



@end
