//
//  idCardAdoptMode.h
//  JYVivoUI2
//
//  Created by junyufr on 16/5/25.
//  Copyright © 2016年 timedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContinuingNetworking.h"

@interface idCardAdoptMode : NSObject

//注：此单例，用于记录各种信息，不仅限于身份证





@property(nonatomic,assign) bool adopt;


@property(nonatomic,assign) bool photoGraph;


@property(nonatomic,assign) int numberOne;


@property(nonatomic,strong)NSMutableArray *btnArray;

// 正在输入身份证ID
@property(nonatomic,assign)bool writingIdNumber;


@property(nonatomic,strong) UIImage* idCardImage;//身份证小头像


//json中的info字段
@property(nonatomic,strong) NSString *info;

//是否初始化SO
@property(nonatomic,assign) int libInit;

//当前正处于哪个界面
@property(nonatomic,assign) int severalController;


//信息
@property (nonatomic,strong) NSString *taskGuid;

@property (nonatomic,strong) NSString *name;//姓名
@property (nonatomic,strong) NSString *idCardNumber;//证件号



@property (nonatomic, strong) NSArray* photos;




// 比对结果，0成功，-1失败(默认)，1无法判定修改为0成功，-1无法判定，<-1失败
@property (nonatomic) int compareSuccess;

// 结果信息
@property (nonatomic, retain) NSString* resultInfo;
// 服务器三通测试结果信息
@property (nonatomic, retain) NSArray* resultInfos;



////////////////////////////////////////////////////
// 打包待上传数据
@property (nonatomic, strong) NSData* packagedData;
// 现场照
@property (nonatomic, strong) NSData* selfData;
// 证件照片
@property (nonatomic, strong) NSData* idCardData;
////////////////////////////////////////////////////






@end
