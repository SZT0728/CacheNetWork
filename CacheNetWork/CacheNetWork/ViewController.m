//
//  ViewController.m
//  CacheNetWork
//
//  Created by SZT on 16/3/21.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "ViewController.h"
#import "CacheNetWork.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [CacheNetWork getWithUrlString:@"http://api.guozhoumoapp.com/v1/channels/22/items?limit=20&offset=0" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@",rootDict);
    }];
}

- (IBAction)btnAction:(UIButton *)sender {
    
    CacheNetWork *cnk = [CacheNetWork shareCacheNetWork];
    [CacheNetWork getWithUrlString:@"http://api.guozhoumoapp.com/v1/channels/22/items?limit=20&offset=0" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@",rootDict);
    }];

    
    
}
@end
