//
//  FirstViewController.m
//  pop_Animated
//
//  Created by kkqb on 2017/1/5.
//  Copyright © 2017年 swift_wach. All rights reserved.
//

#import "FirstViewController.h"

#import "SecondViewController.h"

#import "RZTransitionsInteractionControllers.h"
#import "RZTransitionsAnimationControllers.h"

#import "RZTransitionsManager.h"

@interface FirstViewController ()<RZTransitionInteractionControllerDelegate>

@property (nonatomic, strong) id<RZTransitionInteractionController> pushPopInteractionController;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pushPopInteractionController = [[RZHorizontalInteractionController alloc] init];
    [self.pushPopInteractionController setNextViewControllerDelegate:self];
    [self.pushPopInteractionController attachViewController:self withAction:RZTransitionAction_PushPop];
    
    [[RZTransitionsManager shared] setInteractionController:self.pushPopInteractionController
                                         fromViewController:[self class]
                                           toViewController:nil
                                                  forAction:RZTransitionAction_PushPop];
    
    [[RZTransitionsManager shared] setAnimationController:[[RZCardSlideAnimationController alloc] init]
                                       fromViewController:[self class]
                                                forAction:RZTransitionAction_PushPop];
    
    [[RZTransitionsManager shared] setAnimationController:[[RZZoomPushAnimationController alloc] init]
                                       fromViewController:[self class]
                                         toViewController:[SecondViewController class]
                                                forAction:RZTransitionAction_PushPop];
    
    self.title = @"第一页";
    
    self.view.backgroundColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.4 alpha:1];
    
    UIButton *leaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leaveBtn.frame = CGRectMake(100, 200, 100, 40);
    
    [leaveBtn setTitle:@"push" forState:0];
    [leaveBtn setTitleColor:[UIColor whiteColor] forState:0];
    
    leaveBtn.backgroundColor = [UIColor greenColor];
    
    [leaveBtn addTarget:self action:@selector(leaveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leaveBtn];
    
}

- (void)leaveBtnClick:(UIButton *)btn{
    
    SecondViewController *VC = [[SecondViewController alloc] init];
    
    VC.title = @"第二页";
    
    
    
    [self.navigationController pushViewController:VC animated:YES];
    
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
