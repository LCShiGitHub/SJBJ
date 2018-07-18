//
//  ViewController.m
//  zhibo.video
//
//  Created by kkqb on 2017/3/10.
//  Copyright © 2017年 swift_wach. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "PlayVideoViewController.h"

@interface ViewController ()

@property (nonatomic ,strong) NSString *url;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 200, 50);
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn addTarget:self action:@selector(PlayClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"播放" forState:0];
    [self.view addSubview:btn];
    
    
    
    
    
}
- (void)PlayClick:(UIButton *)btn{
    PlayVideoViewController *Vc = [[PlayVideoViewController alloc] init];
    
    [self presentViewController:Vc animated: YES completion:nil];
//    [self.navigationController pushViewController:Vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
