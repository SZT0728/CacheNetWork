//
//  CacheNetWork.h
//  网络数据离线缓存
//
//  Created by SZT on 16/3/21.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^requessSucceed)(NSData *data,NSURLResponse *response,NSError *error);

@interface CacheNetWork : NSObject


@property(nonatomic,strong)NSCache *myCache;


//普通get请求支持内存缓存和沙盒缓存
+ (void)getWithUrlString:(NSString *)urlString  completionHandler:(requessSucceed)completionBlock;


+ (void)postWithUrlString:(NSString *)urlString  parameter:(NSDictionary *)dict completionhandler:(requessSucceed)completionBlock;

+ (void)doingCompletionBlock:(requessSucceed)succeed WithDict:(NSDictionary *)dict;


+ (CacheNetWork *)shareCacheNetWork;

@end
