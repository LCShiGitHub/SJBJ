//
//  PNCGestureLockView.h
//  PNCLockView
//
//  Created by 二哈 on 16/4/27.
//  Copyright © 2016年 侯森魁. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^CallBackPassword)(NSString *password);

@interface PNCGestureLockView : UIView

//正常图片
@property (nonatomic,copy)NSString *normalImage;
//选中的图片
@property (nonatomic,copy)NSString *selectedImage;
//线的颜色
@property (nonatomic,strong)UIColor *lineColor;
//线宽
@property (nonatomic,assign)CGFloat lineWidth;
//按钮的宽度
@property (nonatomic,assign)CGFloat btnWidth;

//绘制结束返回的密码
@property (nonatomic,copy)CallBackPassword callBackPassword;

- (id)initWithFrame:(CGRect)frame normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth btnWidth:(CGFloat)btnWidth;
@end
