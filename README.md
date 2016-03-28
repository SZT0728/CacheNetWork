# CacheNetWork
##前言
CacheNetWork一个轻量级的支持离线缓存的框架
在应用开发中离线缓存是一个提高用户体验必不可少的操作，若应用程序没有进行内存缓存和离线缓存，频繁的请求网络数据会使得用户体验及其不佳，不仅如此，同时也消耗更多的流量，造成一种资源浪费。在网络状态不稳定或是断网的时候会有时还会出现意料不到的一些突发事件。本框架旨在为应用程序提供内存缓存和离线缓存。使用该框架来进行网络数据请求将会自动增加了内存缓存和离线缓存的功能，而且不需要你考虑何时有缓存，何时应该拿出缓存来加载数据。目前已经实现了get请求和post请求的内存缓存和离线缓存。
##应用
###1,get请求
####方法
```
/**
 *  普通get请求，支持内存缓存，沙盒缓存
 *  @param urlString :请求的url字符串
 *  @param completionBlock :请求完成之后回调的block
 */
+ (void)getWithUrlString:(NSString *)urlString  completionHandler:(requessSucceed)completionBlock failure:(requestFailure)failBlock;
```
Example:
发送一个普通的get请求
```
/**
     *  普通get请求，支持内存缓存，沙盒缓存
     *
     *  @param data     请求到的data数据
     *  @param response 响应头
     *  @param error    请求出错时包含的错误信息
     *
     *  @return 
     */
   [CacheNetWork getWithUrlString:@"http://api.guozhoumoapp.com/v1/channels/22/items?limit=20&offset=0" completionHandler:^(NSData *data, NSURLResponse *response) {
        //该block是在请求成功之后回调
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
       //该block是在发送请求失败的时候回调
    }];


```
###2,post请求
####方法
```
/**
 *  普通post请求支持内存缓存和沙盒缓存
 *
 *  @param urlString       请求的url字符串
 *  @param dict            请求附带的参数
 *  @param completionBlock 请求完成之后回调的block
 */
+ (void)postWithUrlString:(NSString *)urlString  parameter:(NSDictionary *)dict completionhandler:(requessSucceed)completionBlock failBlock:(requestFailure)failBlock;
```
Example:
发送一个post请求
```
   [CacheNetWork postWithUrlString:self.postUrl parameter:self.dic completionhandler:^(NSData *data, NSURLResponse *response) {
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //该block是在请求成功之后回调
    } failBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
       //该block是在发送请求失败的时候回调
    }];

```
###3,下载
####方法
```
/**
    下载操作
 *
 *  @param urlString       下载的UrlString
 *  @param downLoadSucceed 下载结束的时候回调
 *  @param resumedownload  当任务中断后又重新开始下载的时候调用
 *  @param progress        下载进度
 *
 *  @return 下载的任务
 */
+ (NSURLSessionDownloadTask *)downloadFileWithUrlString:(NSString *)urlString finishedDownLoad:(DownLoadSucceed)downLoadSucceed resumeDownLoad:(DownloadResume)resumedownload currentProgress:(DownLoadprogress)progress;

/**
 *   暂停某个下载任务
 *
 *  @param downLoadtask 要暂停的下载任务
 */
+ (void)cancelDownLoadWithTask:(NSURLSessionDownloadTask *)downLoadtask;


/**
 *  继续某个下载任务
 *
 *  @param downLoadTask 要继续下载的任务
 */
+ (void)continueDownLoadWithTask:(NSURLSessionDownloadTask *)downLoadTask;
```
Example:
执行一个下载操作
```
NSURLSessionDownloadTask *task = [CacheNetWork downloadFileWithUrlString:downLoadUrl finishedDownLoad:^(NSURLSession *session, NSURLSessionDownloadTask *downLoadTask, NSURL *fileLocation) {
        
       //下载完成的时候会回调该block
    
    } resumeDownLoad:^(NSURLSession *session, NSURLSessionDownloadTask *downLoadTask, int64_t fileOffset, int64_t expectedTotalBytes) {
        //任务从中断状态又继续的时候会回调该block
    } currentProgress:^(NSURLSession *session, NSURLSessionDownloadTask *downLoadTask, double progress) {
        //执行下载操作过程种会一直调用该block，该Block会频繁的调用，可以在block种获得下载进度
    }];
    [task resume];
    
//暂停任务task
[ [CacheNetWork shareCacheNetWork] cancelDownLoadWithTask:task];

// 恢复下载任务
[ [CacheNetWork shareCacheNetWork] continueDownLoadWithTask:task];
```
