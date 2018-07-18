//
//  LoginCheckBox.h
//  JYVivoUI2
//
//  Created by jock li on 16/4/26.
//  Copyright © 2016年 timedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginCheckBox : UIView

@property IBInspectable (nonatomic, copy) NSString* title;

@property IBInspectable (nonatomic, retain) UIImage* imageOff;

@property IBInspectable (nonatomic, retain) UIImage* imageOn;

@property(nonatomic, assign) BOOL rememberPassword;

@end
