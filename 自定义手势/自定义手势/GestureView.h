//
//  GestureView.h
//  自定义手势
//
//  Created by kkqb on 16/7/7.
//  Copyright © 2016年 kkqb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GestureView : UIView

{
    UILabel *typelabel;
    
    NSInteger type;   //设置或者验证
    
    NSInteger count;

}
@property (nonatomic , assign)BOOL isreplace;

- (void) setUI;

@end
