//
//  RecognitionController.h
//  JYVivoUI2
//
//  Created by jock li on 16/4/27.
//  Copyright © 2016年 timedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "ContinuingNetworking.h"


@interface RecognitionController : UIViewController //环境检测，活体检测2个界面的控制器

@property(nonatomic, retain) Person* personInfo;

@property(nonatomic, assign) bool bOcrStart;


@property(nonatomic, strong)ContinuingNetworking *continuingNetworking;



@end
