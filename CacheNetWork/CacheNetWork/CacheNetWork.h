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

//普通post请求支持内存缓存和沙盒缓存
+ (void)postWithUrlString:(NSString *)urlString  parameter:(NSDictionary *)dict completionhandler:(requessSucceed)completionBlock;

//将字典里面的值出去来作为block的参数执行block
//+ (void)doingCompletionBlock:(requessSucceed)succeed WithDict:(NSDictionary *)dict;

//获取缓存框架的管理者，是一个单利
//+ (CacheNetWork *)shareCacheNetWork;


+ (void)clearSandBoxCache;

@end
