//
//  GestureView.m
//  自定义手势
//
//  Created by kkqb on 16/7/7.
//  Copyright © 2016年 kkqb. All rights reserved.
//

#import "GestureView.h"

#import "PNCGestureLockView.h"

@implementation GestureView

- (id) initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        
        count = 1;
    }
    return self;
}
- (void)setUI
{
    UIImageView *bgimgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    bgimgview.image = [UIImage imageNamed:@"login_bg"];
    [self addSubview:bgimgview];
    
    UIImageView *logimgview = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-157/2, 40, 157, 137)];
    logimgview.image = [UIImage imageNamed:@"gesture_logo"];
    [self addSubview:logimgview];
    
     NSString *Gesture = [[NSUserDefaults standardUserDefaults] stringForKey:@"Gesture"];
    if ([Gesture isEqualToString:@""]) {
        type = 0;    //没有设置过手势密码
    }else{
        type = 1;    //已经设置了手势密码
    }
    
    PNCGestureLockView *pncView = [[PNCGestureLockView alloc] initWithFrame:CGRectMake(0, 220, self.bounds.size.width, 300) normalImage:@"gesture_yuan_down" selectedImage:@"gesture_yuan_up" lineColor:[UIColor colorWithRed:230/255.0 green:217/255.0 blue:203/255.0 alpha:1] lineWidth:8.0 btnWidth:60];
    
    [self addSubview:pncView];
    typelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 160, self.bounds.size.width, 30)];
    typelabel.font = [UIFont systemFontOfSize:16];
    if (type == 0) {
       typelabel.text = @"请设置手势密码";
    }
    if (type == 1) {
        typelabel.text = @"请确认手势密码";
    }
    typelabel.backgroundColor = [UIColor clearColor];
    typelabel.textAlignment = NSTextAlignmentCenter;
    typelabel.textColor = [UIColor lightGrayColor];
    [self addSubview:typelabel];
    
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.bounds.size.width/2 * i, self.bounds.size.height - 50, self.bounds.size.width/2, 30);
        btn.backgroundColor = [UIColor clearColor];
        if (i == 0) {
            [btn setTitle:@"忘记手势密码" forState:0];
        }else{
            [btn setTitle:@"其他账号登录" forState:0];
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor lightGrayColor] forState:0];
        btn.tag = 88+i;
        [btn addTarget:self action:@selector(btngroupClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    [pncView setCallBackPassword:^(NSString *password){
        
        NSLog(@"绘制的密码是:%@",password);
        
        typelabel.textColor = [UIColor lightGrayColor];
        
        if (password.length < 4) {
            typelabel.textColor = [UIColor redColor];
            typelabel.text = @"至少连接四个点";
        }else{
            NSString *word = [[NSUserDefaults standardUserDefaults] stringForKey:@"Gesture"];
            NSLog(@"word:%@",word);
            
            if (self.isreplace) {
                if (type == 2) {
                    if ([word isEqualToString:@""]) {
                        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"Gesture"];
                        typelabel.text = @"请再次输入手势密码";
                    }else{
                        if ([password isEqualToString:word]) {
                            typelabel.text = @"手势密码设置成功";
                            UIWindow *window = [UIApplication sharedApplication].keyWindow;
                            UIView *view = [window viewWithTag:9999];
                            [UIView animateWithDuration:1.0 animations:^{
                                view.alpha = 0;
                            } completion:^(BOOL finished) {
                                [view removeFromSuperview];
                            }];
                            //                        type = 1;
                        }else{
                            typelabel.textColor = [UIColor redColor];
                            typelabel.text = @"前后密码设置不一致";
                        }
                    }
                    
                    
                }else{
                if ([password isEqualToString:word]) {
                    typelabel.text = @"请设置新密码";
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Gesture"];
                    type = 2;
                }else{
                    typelabel.textColor = [UIColor redColor];
                    
                    typelabel.text = [NSString stringWithFormat:@"验证失败，您还剩%ld次机会",3 - count];
                    
                    count ++;
                }
                }
                
                
            }else{
            if (type == 1) {
                if ([password isEqualToString:word]) {
                    typelabel.text = @"手势密码验证成功";
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    UIView *view = [window viewWithTag:9999];
                    [UIView animateWithDuration:1.0 animations:^{
                        view.alpha = 0;
                    } completion:^(BOOL finished) {
                        [view removeFromSuperview];
                    }];
                }else{
                    typelabel.textColor = [UIColor redColor];
                    
                    typelabel.text = [NSString stringWithFormat:@"验证失败，您还剩%ld次机会",3 - count];
                    count ++;
                }
            }
            if (type == 0) {
                
                if ([word isEqualToString:@""]) {
                    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"Gesture"];
                    typelabel.text = @"请再次输入手势密码";
                }else{
                    if ([password isEqualToString:word]) {
                        typelabel.text = @"手势密码设置成功";
                        UIWindow *window = [UIApplication sharedApplication].keyWindow;
                        UIView *view = [window viewWithTag:9999];
                        [UIView animateWithDuration:1.0 animations:^{
                            view.alpha = 0;
                        } completion:^(BOOL finished) {
                            [view removeFromSuperview];
                        }];
//                        type = 1;
                    }else{
                        typelabel.textColor = [UIColor redColor];
                        typelabel.text = @"前后密码设置不一致";
                    }
                }
            }
            }

        }
        
    
        
        
        
        
        
    }];
    
}
- (void)btngroupClick:(UIButton *)btn
{
    if (btn.tag == 88) {  //忘记手势密码
       
        
        
    }
    if (btn.tag == 89) {  //其他账号登录
        
        
    }
    
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
