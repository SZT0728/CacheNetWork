# CacheNetWork
##前言
CacheNetWork一个轻量级的支持离线缓存的框架
在应用开发中离线缓存是一个提高用户体验必不可少的操作，若应用程序没有进行内存缓存和离线缓存，频繁的请求网络数据会使得用户体验及其不佳，不仅如此，同时也消耗更多的流量，造成一种资源浪费。在网络状态不稳定或是断网的时候会有时还会出现意料不到的一些突发事件。本框架旨在为应用程序提供内存缓存和离线缓存。使用该框架来进行网络数据请求将会自动增加了内存缓存和离线缓存的功能，而且不需要你考虑何时有缓存，何时应该拿出缓存来加载数据。目前已经实现了get请求和post请求的内存缓存和离线缓存。
##应用
###1,get请求
```
/**
 *  普通get请求，支持内存缓存，沙盒缓存
 *  @param urlString :请求的url字符串
 *  @param completionBlock :请求完成之后回调的block
 */
+ (void)getWithUrlString:(NSString *)urlString  completionHandler:(requessSucceed)completionBlock;
```
