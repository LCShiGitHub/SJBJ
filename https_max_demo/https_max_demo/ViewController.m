//
//  ViewController.m
//  https_max_demo
//
//  Created by kkqb on 2016/12/20.
//  Copyright © 2016年 swift_wach. All rights reserved.
//

#import "ViewController.h"

#import "AFNetworking.h"

//#define HTTPSURL @"https://www.kkqb.cn/appIndex"

//#define HTTPSURL @"http://192.168.1.240:7070/appIndex"

#define HTTPSURL @"https://www.baidu.com"




@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [manager GET:HTTPSURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"请求数据成功:%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        NSLog(@"请求数据失败:%@",error);
        
    }];

    
}
//[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
