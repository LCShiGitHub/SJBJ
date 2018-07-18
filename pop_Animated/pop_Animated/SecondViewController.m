//
//  SecondViewController.m
//  pop_Animated
//
//  Created by kkqb on 2017/1/5.
//  Copyright © 2017年 swift_wach. All rights reserved.
//

#import "SecondViewController.h"

#import "ThirdViewController.h"

#import "RZTransitionsInteractionControllers.h"
#import "RZTransitionsAnimationControllers.h"

#import "RZTransitionsManager.h"

@interface SecondViewController ()<RZTransitionInteractionControllerDelegate>

@property (nonatomic, strong) id<RZTransitionInteractionController> pushPopInteractionController;

@end

@implementation SecondViewController

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

    
    self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.2 blue:0.3 alpha:1];
    
    UIButton *leaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leaveBtn.frame = CGRectMake(100, 200, 100, 40);
    
    [leaveBtn setTitle:@"push" forState:0];
    [leaveBtn setTitleColor:[UIColor whiteColor] forState:0];
    
    leaveBtn.backgroundColor = [UIColor greenColor];
    
    [leaveBtn addTarget:self action:@selector(leaveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leaveBtn];
    
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    popBtn.frame = CGRectMake(100, 300, 100, 40);
    
    [popBtn setTitle:@"pop" forState:0];
    [popBtn setTitleColor:[UIColor whiteColor] forState:0];
    
    popBtn.backgroundColor = [UIColor greenColor];
    
    [popBtn addTarget:self action:@selector(popBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
}

- (void)leaveBtnClick:(UIButton *)btn{
    
    ThirdViewController *VC = [[ThirdViewController alloc] init];
    
    VC.title = @"第三页";
    
    [[RZTransitionsManager shared] setAnimationController:[[RZCardSlideAnimationController alloc] init]
                                       fromViewController:[self class]
                                                forAction:RZTransitionAction_PushPop];
    
    [[RZTransitionsManager shared] setAnimationController:[[RZZoomPushAnimationController alloc] init]
                                       fromViewController:[self class]
                                         toViewController:[ThirdViewController class]
                                                forAction:RZTransitionAction_PushPop];
    
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)popBtnClick:(UIButton *)btn{
    
   
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
