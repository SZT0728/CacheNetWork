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

@property(nonatomic,strong)NSDictionary *dic;

@property(nonatomic,strong)NSString *postUrl;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property(nonatomic,assign)NSInteger index;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = 1;
    
    //get请求的url
    self.urlString = @"http://api.guozhoumoapp.com/v1/channels/22/items?limit=20&offset=0";
    
    
    //post请求的url
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"20131129", @"date", @"1", @"startRecord", @"5", @"len", @"1234567890", @"udid", @"Iphone", @"terminalType", @"213", @"cid", nil];
    self.dic = dic;
    
    NSString *postUrl = @"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?";
    self.postUrl = postUrl;

    
    
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
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (rootDict != nil) {
            self.label.text = [NSString stringWithFormat:@"%ld",++self.index];
            NSLog(@"%@get 1拿到数据",rootDict);
        }
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSLog(@"%@ get请求失败，出错error",error);
    }];
    /**
     *  普通post请求
     *
     *  @param data     请求得到数据
     *  @param response 请求得到响应头
     *  @param error    请求出错时包含的错误信息
     *
     *  @return
     */
    [CacheNetWork postWithUrlString:self.postUrl parameter:self.dic completionhandler:^(NSData *data, NSURLResponse *response) {
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (rootDict != nil) {
            self.label.text = [NSString stringWithFormat:@"%ld",++self.index];
            NSLog(@"%@post 1拿到数据",rootDict);

        }
    } failBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSLog(@"%@ post请求失败，出错error",error);
    }];
    
}

- (IBAction)downLoad:(id)sender {
    
    NSString *downLoadUrl = @"http://localhost:8080/MJServer/resources/videos/minion_01.mp4";
    NSURLSessionDownloadTask *task = [CacheNetWork downloadFileWithUrlString:downLoadUrl finishedDownLoad:^(NSURLSession *session, NSURLSessionDownloadTask *downLoadTask, NSURL *fileLocation) {
        
        NSString *docFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *moviePath = [docFile stringByAppendingPathComponent:downLoadTask.response.suggestedFilename];
//        NSLog(@"----------%@",moviePath);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager moveItemAtPath:fileLocation.path toPath:moviePath error:nil];
        
        
    } resumeDownLoad:^(NSURLSession *session, NSURLSessionDownloadTask *downLoadTask, int64_t fileOffset, int64_t expectedTotalBytes) {
        
        NSLog(@"+++++++++++");
        
    } currentProgress:^(NSURLSession *session, NSURLSessionDownloadTask *downLoadTask, double progress) {
        
    }];
    [task resume];
    
    
    
}



/**
 *  重复请求操作
 *
 */
- (IBAction)btnAction:(UIButton *)sender {
    
    
    [CacheNetWork postWithUrlString:self.postUrl parameter:self.dic completionhandler:^(NSData *data, NSURLResponse *response) {
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (rootDict != nil) {
            self.label.text = [NSString stringWithFormat:@"%ld",++self.index];
            NSLog(@"%@post拿到数据",rootDict);
        }
    } failBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSLog(@"%@ 请求失败，出错error",error);
    }];
    
    
    [CacheNetWork getWithUrlString:@"http://api.guozhoumoapp.com/v1/channels/22/items?limit=20&offset=0" completionHandler:^(NSData *data, NSURLResponse *response) {
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (rootDict != nil) {
            self.label.text = [NSString stringWithFormat:@"%ld",++self.index];
            NSLog(@"%@get拿到数据",rootDict);
        }
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
    }];
    
}




@end
