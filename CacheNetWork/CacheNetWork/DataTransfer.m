//
//  DataTransfer.m
//  CacheNetWork
//
//  Created by SZT on 16/3/22.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "DataTransfer.h"

@implementation DataTransfer



+ (NSMutableData *)dataFromDict:(NSDictionary *)dict
{
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archive encodeObject:dict forKey:@"dict"];
    [archive finishEncoding];
    return data;
}

+ (NSDictionary *)dictFromData:(NSMutableData *)data
{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSDictionary *dict = [unarchiver decodeObjectForKey:@"dict"];
    [unarchiver finishDecoding];
    return dict;
}

@end
