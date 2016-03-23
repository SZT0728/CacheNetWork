//
//  ViewController.m
//  CacheNetWork
//
//  Created by SZT on 16/3/21.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "ViewController.h"
#import "CacheNetWork.h"
#import "CacheDataBase.h"

@interface ViewController ()

@property(nonatomic,strong)NSString *urlString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.urlString = @"http://api.guozhoumoapp.com/v1/channels/22/items?limit=20&offset=0";
    /**
     *  普通get请求，支持内存缓存，沙盒缓存
     *
     *  @param data     请求到的data数据
     *  @param response 响应头
     *  @param error    请求出错时包含的错误信息
     *
     *  @return 
     */
    /*
    [CacheNetWork getWithUrlString:@"http://api.guozhoumoapp.com/v1/channels/22/items?limit=20&offset=0" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@",rootDict);
    }];
     */
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"20131129", @"date", @"1", @"startRecord", @"5", @"len", @"1234567890", @"udid", @"Iphone", @"terminalType", @"213", @"cid", nil];
    NSMutableString *httpMethod = [NSMutableString new];
    for (NSString *key in dic.allKeys) {
        NSString *value = dic[key];
        [httpMethod appendFormat:@"&%@=%@",key,value];
    }
    NSString *theString = [httpMethod substringFromIndex:1];
//    NSLog(@"theString = %@",theString);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [theString dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求失败");
        }else{
            NSLog(@"请求成功");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            NSLog(@"request data is = %@",dict);
        }
    }];
    [task resume];
}

- (IBAction)btnAction:(UIButton *)sender {
    
//    CacheNetWork *cnk = [CacheNetWork shareCacheNetWork];
    [CacheNetWork getWithUrlString:@"http://api.guozhoumoapp.com/v1/channels/22/items?limit=20&offset=0" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@",rootDict);
    }];
    


    
    
}
@end
