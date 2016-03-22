//
//  DataTransfer.h
//  CacheNetWork
//
//  Created by SZT on 16/3/22.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataTransfer : NSObject



+ (NSMutableData *)dataFromDict:(NSDictionary *)dict;

+ (NSDictionary *)dictFromData:(NSMutableData *)data;


@end
