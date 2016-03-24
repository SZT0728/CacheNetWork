//
//  DataTransfer.h
//  CacheNetWork
//
//  Created by SZT on 16/3/22.
//  Copyright © 2016年 SZT. All rights reserved.
//



/**
 *  常见的数据转换类
 */
#import <Foundation/Foundation.h>

@interface DataTransfer : NSObject


//字典转换为data类型
+ (NSMutableData *)dataFromDict:(NSDictionary *)dict;

//data类型转换了字典类型
+ (NSDictionary *)dictFromData:(NSData *)data;


@end
