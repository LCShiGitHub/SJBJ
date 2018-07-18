//
//  LoginCheckBox.m
//  JYVivoUI2
//
//  Created by jock li on 16/4/26.
//  Copyright © 2016年 timedge. All rights reserved.
//

#import "LoginCheckBox.h"


#define CHECK_BOX_FRAME CGRectMake(23, 12, 15, 15)

@interface LoginCheckBox ()

@property (nonatomic,strong) UIImageView *imageV;

@end

@implementation LoginCheckBox

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initSelf];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (void)initSelf
{
    self.userInteractionEnabled = YES;
    
    self.backgroundColor = [UIColor colorWithRed:24/255.0 green:122/255.0 blue:196/255.0 alpha:1];
    
    self.imageOn = [UIImage imageNamed:@"btn_check_on"];
    self.imageOff = [UIImage imageNamed:@"btn_check_off"];
    self.title = @"保存信息";
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(23, 12, 15, 15)];
    self.imageV = imageV;
    [self addSubview:imageV];
    
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.size.width+imageV.frame.origin.x+5, 0, self.frame.size.width - (imageV.frame.size.width+imageV.frame.origin.x+5), self.frame.size.height)];
    titleL.text = @"保存信息";
    titleL.textColor = [UIColor whiteColor];
    titleL.textAlignment = NSTextAlignmentCenter;//居中显示
    [self addSubview:titleL];
    
    
    //偏好设置是否记住密码
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"rememberPassword"];
    if ([str  isEqual:@"YES"])
    {
        self.rememberPassword = YES;
        self.imageV.image = self.imageOn;
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"rememberPassword"];
    }else
    {
        self.rememberPassword = NO;
        self.imageV.image = self.imageOff;
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"rememberPassword"];
    }
}

- (void)touchIn
{
    self.rememberPassword = !self.rememberPassword;
    if (self.rememberPassword == YES) {
        self.imageV.image = self.imageOn;
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"rememberPassword"];
    }else{
        self.imageV.image = self.imageOff;
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"rememberPassword"];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    
    [self touchIn];
}


@end
