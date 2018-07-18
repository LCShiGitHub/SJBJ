//
//  ViewController.m
//  ipone
//
//  Created by kkqb on 16/10/12.
//  Copyright © 2016年 chinapeihu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *scriptimgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 200, 200, 150)];
//    scriptimgView.image = [UIImage imageNamed:@"baiseduih"];
    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"baiseduih" ofType:@"png"]];
    
    NSLog(@"wid:%.2f,height:%.2f",bubble.size.width,bubble.size.height);
    
    CGFloat top = bubble.size.height * 0.9;
    CGFloat left = bubble.size.width * 0.5;
    CGFloat bottom = bubble.size.height * 0.1;
    CGFloat right = bubble.size.width * 0.5;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    // 指定为拉伸模式，伸缩后重新赋值
    bubble = [bubble resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
//    UIImageView *scriptimgView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    
//    bubbleImageView.frame = CGRectMake(20, 200, 200, 100);
    
//    NSLog(@"%f,%f",size.width,size.height);
    
    scriptimgView.image = bubble;
    
    [self.view addSubview:scriptimgView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 400, 131*2, 41*2)];
    imgView.image = [UIImage imageNamed:@"baiseduih"];
    [self.view addSubview:imgView];
    
   
//    UIView *view = [self bubbleView:@"baiseduihbaiseduihbaiseduihbaiseduihbaiseduihbaiseduih" from:YES withPosition:10];
//    [self.view addSubview:view];

    
   

}

//泡泡文本
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position{
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:14];
//    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
//    CGSize zise = [text sizew];
    
    // build single chat bubble cell with given text
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];
    
    //背影图片
    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"baiseduih":@"baiseduih" ofType:@"png"]];
    
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    NSLog(@"%f,%f",200.0,100.0);
    
    
    //添加文本信息
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?15.0f:22.0f, 20.0f, 200, 100)];
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.text = text;
    
    bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
    
    if(fromSelf)
        returnView.frame = CGRectMake(320-position-(bubbleText.frame.size.width+30.0f), 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    else
        returnView.frame = CGRectMake(position, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    
    [returnView addSubview:bubbleImageView];
    [returnView addSubview:bubbleText];
    
    return returnView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
