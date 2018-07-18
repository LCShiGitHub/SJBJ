//
//  ShoushiViewController.m
//  自定义手势
//
//  Created by kkqb on 16/7/6.
//  Copyright © 2016年 kkqb. All rights reserved.
//

#import "ShoushiViewController.h"

#import "GestureView.h"

#import "RegistViewController.h"

@interface ShoushiViewController ()
@end

@implementation ShoushiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UIApplicationDidEnterBackgroundNotification  //进入后台
    //UIApplicationWillEnterForegroundNotification //回到程序
    
    //增加程序进入前台的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneInForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    //增加程序进入后台的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneInBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    
    self.navigationController.navigationBarHidden = YES;
    
//     NSString *Gesture = [[NSUserDefaults standardUserDefaults] stringForKey:@"Gesture"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Gesture"];
    
    NSArray *titles = @[@"设置手势密码",@"重置手势密码",@"下一页"];
    for (int i = 0; i < 3; i ++) {
        UIButton *setbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        setbtn.frame = CGRectMake(0, 200+60*i, [UIScreen mainScreen].bounds.size.width, 30);
        [setbtn setTitle:titles[i] forState:0];
        [setbtn setTitleColor:[UIColor redColor] forState:0];
        setbtn.tag = 10+i;
        [setbtn addTarget:self action:@selector(setbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:setbtn];
    }
    
    
    
    
}
- (void)setbtnClick:(UIButton *)btn
{
    if (btn.tag == 12) {
//        RegistViewController *vc = [[RegistViewController alloc] init];
//        
//        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        
//        [self presentViewController:vc animated:YES completion:^{
//            
//        }];
//        NSString *url = @"itms-apps://itunes.apple.com/cn/app/kan-kan-qian-bao/id1131529380?mt=8";
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    GestureView *view = [[GestureView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
   
    view.tag = 9999;
    
    if (btn.tag == 10) {
        view.isreplace = NO;
        [btn setTitle:@"验证手势密码" forState:0];
    }else if(btn.tag == 11 ){
        view.isreplace = YES;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Gesture"] isEqualToString:@""]) {
            return;
        }
    }
    
    [view setUI];
    [window addSubview:view];
    
}
- (void) appHasGoneInForeground:(NSNotification *)notification
{
    NSLog(@"通知收到，程序就入前台");
}
- (void) appHasGoneInBackground:(NSNotification *)notification
{
    NSLog(@"通知收到，程序进入后台");
}
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
