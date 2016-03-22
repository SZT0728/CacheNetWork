//
//  CacheNetWork.m
//  网络数据离线缓存
//
//  Created by SZT on 16/3/21.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "CacheNetWork.h"

@interface CacheNetWork()<NSURLSessionDelegate>

@end


static CacheNetWork *cacheNetWork = nil;

@implementation CacheNetWork


+ (CacheNetWork *)shareCacheNetWork
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheNetWork = [[CacheNetWork alloc]init];
        cacheNetWork.myCache = [[NSCache alloc]init];
    });
    return cacheNetWork;
}


+ (void)getWithUrlString:(NSString *)urlString  completionHandler:(requessSucceed)completionBlock
{
    CacheNetWork *CNK = [CacheNetWork shareCacheNetWork];
    NSDictionary *dataDict = [CNK.myCache objectForKey:urlString];
    if (dataDict) {
        NSData *data = dataDict[@"data"];
        NSURLResponse *response = dataDict[@"response"];
        NSError *error = dataDict[@"error"];
        completionBlock(data,response,error);
    }else{
    
        NSURLSessionConfiguration *sessionConfigure = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfigure delegate:CNK delegateQueue:[NSOperationQueue mainQueue]];
        
            NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"请求出错：%@",error);
                }else{
                    //请求成功后将数据存入到缓存中
                    NSDictionary *cacheDict = @{@"data":data,@"response":response};
                    [CNK.myCache setObject:cacheDict forKey:urlString];
                    //执行block
                    completionBlock(data,response,error);
                    NSLog(@"%@",[NSThread currentThread]);
                }
            }];
            [task resume];

    }
}

@end
