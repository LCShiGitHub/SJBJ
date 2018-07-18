//
//  PlayVideoViewController.m
//  zhibo.video
//
//  Created by kkqb on 2017/3/10.
//  Copyright © 2017年 swift_wach. All rights reserved.
//

#import "PlayVideoViewController.h"

#import "UIImageView+AFNetworking.h"

#import <IJKMediaFramework/IJKMediaFramework.h>

@interface PlayVideoViewController ()
@property (nonatomic , strong) UIImageView *imageView;

@property (nonatomic , strong) IJKFFMoviePlayerController *Player;

@end

@implementation PlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    // 拉流地址
    NSURL *url = [NSURL URLWithString:self.stream_addr];
    
    // 创建IJKFFMoviePlayerController：专门用来直播，传入拉流地址就好了
    IJKFFMoviePlayerController *playerVc = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
    
    // 准备播放
    [playerVc prepareToPlay];
    
    // 强引用，反正被销毁
    self.Player = playerVc;
    
    playerVc.view.frame = [UIScreen mainScreen].bounds;
    
    [self.view insertSubview:playerVc.view atIndex:1];
    
    [self setnaviegationBar];
}
- (void)setnaviegationBar{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    view.backgroundColor = [UIColor lightGrayColor];
    view.alpha = 0.5;
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.frame = CGRectMake(80, 20, [UIScreen mainScreen].bounds.size.width - 160, 40);
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textColor = [UIColor blackColor];
    topLabel.text = self.name;
    topLabel.font = [UIFont systemFontOfSize:16];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:topLabel];
   
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.alpha = 0.5;
    btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 74, 25, 30, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:25];
    [btn setTitle:@"X" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor lightGrayColor] forState:0];
    btn.layer.cornerRadius = 15;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(blackLick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    [self.view addSubview:view];
    
}
- (void)blackLick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 界面消失，一定要记得停止播放
    [self.Player pause];
    [self.Player stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
