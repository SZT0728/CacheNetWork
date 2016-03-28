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


@property(nonatomic,copy)DownLoadprogress  downLoadProgress;

@property(nonatomic,copy)DownloadResume  downLoadResume;

@property(nonatomic,copy)DownLoadSucceed  downLoadSucceed;


@property(nonatomic,strong)NSURLSession *downLoadSession;



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



/**
 *  普通get请求，支持内存缓存，沙盒缓存
 *
 *  @param data     请求到的data数据
 *  @param response 响应头
 *  @param error    请求出错时包含的错误信息
 *
 *  @return
 */
+ (void)getWithUrlString:(NSString *)urlString  completionHandler:(requessSucceed)completionBlock failure:(requestFailure)failBlock
{
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlString] cachePolicy:(NSURLRequestReturnCacheDataElseLoad) timeoutInterval:5];
    CacheNetWork *CNK = [CacheNetWork shareCacheNetWork];
    NSCachedURLResponse *cacheURLResponse = [[NSURLCache sharedURLCache]cachedResponseForRequest:request];
    if (cacheURLResponse) {
        
        [self doingCompletionBlock:completionBlock WitCacheURLRespnse:cacheURLResponse];
        
    }else{
        NSURLSessionConfiguration *sessionConfigure = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfigure delegate:CNK delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                failBlock(task,error);
            }else{
                
                //执行block
                completionBlock(data,response);
                
            }
        }];
        [task resume];
    }
}

/**
 *  普通post请求
 *
 *  @param data     请求得到数据
 *  @param response 请求得到响应头
 *  @param error    请求出错时包含的错误信息
 *
 *  @return
 */
+ (void)postWithUrlString:(NSString *)urlString  parameter:(NSDictionary *)dict completionhandler:(requessSucceed)completionBlock failBlock:(requestFailure)failBlock
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
                    failBlock(task,error);
                }else{
                    //请求成功后将数据存入到缓存中
                    NSDictionary *cacheDict = @{@"data":data,@"response":response};
                    [CNK.myCache setObject:cacheDict forKey:urlString];
                    
                    //同时存储到沙盒当中
                    [CacheDataBase insertDict:cacheDict WithMainKey:urlString];
                    //执行block
                    completionBlock(data,response);
                }
            }];
            [task resume];
        }
    }
}


/**
 *  将字典dict中的数据获取出来并且作为block的参数执行block
 *
 *  @param succeed 要执行的block
 *  @param dict    字典
 */
+ (void)doingCompletionBlock:(requessSucceed)succeed WithDict:(NSDictionary *)dict
{
    NSData *data = dict[@"data"];
    NSURLResponse *response = dict[@"response"];
    
    succeed(data,response);
}

+ (void)doingCompletionBlock:(requessSucceed)succeed WitCacheURLRespnse:(NSCachedURLResponse *)cacheURLResponse
{
    NSData *data = cacheURLResponse.data;
    NSURLResponse *response = cacheURLResponse.response;
    succeed(data,response);
}

/**
 *  清除沙盒缓存
 */
+ (void)clearSandBoxCache
{
    [CacheDataBase deleteAllData];
}


+ (NSURLSessionDownloadTask *)downloadFileWithUrlString:(NSString *)urlString finishedDownLoad:(DownLoadSucceed)downLoadSucceed resumeDownLoad:(DownloadResume)resumedownload currentProgress:(DownLoadprogress)progress
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:[CacheNetWork shareCacheNetWork] delegateQueue:[NSOperationQueue mainQueue]];
    [CacheNetWork shareCacheNetWork].downLoadSession = session;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url];
    [task resume];
    CacheNetWork *CNK = [CacheNetWork shareCacheNetWork];
    CNK.downLoadSucceed = downLoadSucceed;
    CNK.downLoadProgress = progress;
    CNK.downLoadResume = resumedownload;
    return task;
}



/**
 *  下载结束的时候调用
 *
 *  @param location     下载好之后文件存储的位置
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    self.downLoadSucceed(session,downloadTask,location);
}

/**
 *  恢复下载时调用
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    self.downLoadResume(session,downloadTask,fileOffset,expectedTotalBytes);
}


/**
 *  每当下载完（写完）一部分时就会调用（可能会被调用多次）
 *
 *  @param bytesWritten              这次调用写了多少
 *  @param totalBytesWritten         累计写了多少长度到沙盒中了
 *  @param totalBytesExpectedToWrite 文件的总长度
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    double progress = (double)totalBytesWritten / totalBytesExpectedToWrite;
    self.downLoadProgress(session,downloadTask,progress);
}

/**
 *   暂停某个下载任务
 *
 *  @param downLoadtask 要暂停的下载任务
 */
+ (void)cancelDownLoadWithTask:(NSURLSessionDownloadTask *)downLoadtask
{
    [downLoadtask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        [[CacheNetWork shareCacheNetWork].myCache setObject:resumeData forKey: downLoadtask.response.suggestedFilename];
    }];
}


/**
 *  继续某个下载任务
 *
 *  @param downLoadTask 要继续下载的任务
 */
+ (void)continueDownLoadWithTask:(NSURLSessionDownloadTask *)downLoadTask
{
    NSData *resumeData = [[CacheNetWork shareCacheNetWork].myCache objectForKey:downLoadTask.response.suggestedFilename];
    [[CacheNetWork shareCacheNetWork].downLoadSession downloadTaskWithResumeData:resumeData];
    [downLoadTask resume];
    
}






@end
