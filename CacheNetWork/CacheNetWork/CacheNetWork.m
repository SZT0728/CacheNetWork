//
//  CacheNetWork.m
//  网络数据离线缓存
//
//  Created by SZT on 16/3/21.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "CacheNetWork.h"
#import "CacheDataBase.h"

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
        
        NSDictionary *fileDict = [CacheDataBase selectDictWithUrlString:urlString];
        if (fileDict) {
            NSData *data = fileDict[@"data"];
            NSURLResponse *response = fileDict[@"response"];
            NSError *error = fileDict[@"error"];
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
                    
                    //存储到沙盒中
                    [CacheDataBase insertDict:cacheDict WithMainKey:urlString];
                    
                    //执行block
                    completionBlock(data,response,error);
                    NSLog(@"%@",[NSThread currentThread]);
                    
                }
            }];
            [task resume];
        }
    }
}


+ (void)postWithUrlString:(NSString *)urlString  parameter:(NSDictionary *)dict completionhandler:(requessSucceed)completionBlock
{
    CacheNetWork *CNK = [CacheNetWork shareCacheNetWork];
    NSDictionary *dataDict = [CNK.myCache objectForKey:urlString];
    if (dataDict) {//判断缓存中是否有数据
        
        [self doingCompletionBlock:completionBlock WithDict:dataDict];
        
    }else{
        NSDictionary *fileDict = [CacheDataBase selectDictWithUrlString:urlString];
        if (fileDict) {
            
            [self doingCompletionBlock:completionBlock WithDict:fileDict];
            
        }else{
            NSURLSession *session = [NSURLSession sharedSession];
            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
            request.HTTPMethod = @"POST";
            NSMutableString *httpMethod = [NSMutableString new];
            for (NSString *key in dict.allKeys) {
                NSString *value = dict[key];
                [httpMethod appendFormat:@"&%@=%@",key,value];
            }
            request.HTTPBody = [[httpMethod substringFromIndex:1] dataUsingEncoding:NSUTF8StringEncoding];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    NSLog(@"请求失败:%@",error);
                }else{
                    //请求成功后将数据存入到缓存中
                    NSDictionary *cacheDict = @{@"data":data,@"response":response};
                    [CNK.myCache setObject:cacheDict forKey:urlString];
                    
                    //同时存储到沙盒当中
                    [CacheDataBase insertDict:cacheDict WithMainKey:urlString];
                    //执行block
                    completionBlock(data,response,error);
                }
                
            }];
            [task resume];
        }
    }
}

+ (void)doingCompletionBlock:(requessSucceed)succeed WithDict:(NSDictionary *)dict
{
    NSData *data = dict[@"data"];
    NSURLResponse *response = dict[@"response"];
    NSError *error = dict[@"error"];
    succeed(data,response,error);
}


@end
