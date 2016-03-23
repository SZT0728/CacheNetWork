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
+ (void)getWithUrlString:(NSString *)urlString  completionHandler:(requessSucceed)completionBlock;
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
    [CacheNetWork getWithUrlString:urlString completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //该block回调的时候：请求完成（成功或者失败）之后回调该block。可通过error是否为nil来判断请求是否成功
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
+ (void)postWithUrlString:(NSString *)urlString  parameter:(NSDictionary *)dict completionhandler:(requessSucceed)completionBlock;
```
Example:
发送一个post请求
```
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"20131129", @"date", @"1", @"startRecord", @"5", @"len", @"1234567890", @"udid", @"Iphone", @"terminalType", @"213", @"cid", nil];
    
    NSString *postUrl = @"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?";
    [CacheNetWork postWithUrlString:postUrl parameter:dic completionhandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //block何时回调同上
    }];
```

