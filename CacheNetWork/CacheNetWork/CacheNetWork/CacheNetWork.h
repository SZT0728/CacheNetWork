//
//  CacheNetWork.h
//  网络数据离线缓存
//
//  Created by SZT on 16/3/21.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>

// 请求数据成功回调block
typedef void(^requessSucceed)(NSData *data,NSURLResponse *response);

//请求数据失败回调的block
typedef void(^requestFailure)(NSURLSessionDataTask *dataTask,NSError *error);

//下载完成回调block
typedef void(^DownLoadSucceed)(NSURLSession *session,NSURLSessionDownloadTask *downLoadTask,NSURL *fileLocation);

//恢复下载调用block
typedef void(^DownloadResume)(NSURLSession *session,NSURLSessionDownloadTask *downLoadTask,int64_t fileOffset,int64_t expectedTotalBytes);

// 下载读取到数据的时候回调
typedef void(^DownLoadprogress)(NSURLSession *session,NSURLSessionDownloadTask *downLoadTask,double progress);

@interface CacheNetWork : NSObject


@property(nonatomic,strong)NSCache *myCache;


//普通get请求支持内存缓存和沙盒缓存
+ (void)getWithUrlString:(NSString *)urlString  completionHandler:(requessSucceed)completionBlock failure:(requestFailure)failBlock;


/**
 *  普通post请求支持内存缓存和沙盒缓存
 *
 *  @param urlString
 *  @param dict
 *  @param completionBlock
 */
+ (void)postWithUrlString:(NSString *)urlString  parameter:(NSDictionary *)dict completionhandler:(requessSucceed)completionBlock failBlock:(requestFailure)failBlock;

/**
 *  清除沙盒缓存
 */
+ (void)clearSandBoxCache;



+ (NSURLSessionDownloadTask *)downloadFileWithUrlString:(NSString *)urlString finishedDownLoad:(DownLoadSucceed)downLoadSucceed resumeDownLoad:(DownloadResume)resumedownload currentProgress:(DownLoadprogress)progress;

//+ (void)cancelDownLoadWith:(NSURLSessionDownloadTask *)downLoadtask;




@end
