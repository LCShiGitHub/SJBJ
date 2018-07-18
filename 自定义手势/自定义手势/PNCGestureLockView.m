//
//  PNCGestureLockView.m
//  PNCLockView
//
//  Created by 二哈 on 16/4/27.
//  Copyright © 2016年 侯森魁. All rights reserved.
//

#import "PNCGestureLockView.h"
/*
 1.按钮布局
 2.划线
 3.抬起
 */
@interface PNCGestureLockView ()
//选中的按钮
@property(nonatomic,strong)NSMutableArray *btns;
//移动时的位置
@property(nonatomic,assign)CGPoint moveP;



@end

@implementation PNCGestureLockView


-(NSMutableArray *)btns
{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (id)initWithFrame:(CGRect)frame normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth btnWidth:(CGFloat)btnWidth
{
    
    if (self =[super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.lineWidth = lineWidth;
        self.lineColor = lineColor;
        self.normalImage = normalImage;
        self.selectedImage = selectedImage;
        self.btnWidth =btnWidth;
        
        [self addSubBtns];
    }
    return self;

    
}
#pragma mark--添加按钮
-(void)addSubBtns
{
    
    for (int i = 0; i < 9; i ++) {
        
        UIButton *button  =[UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setImage:[UIImage imageNamed:self.normalImage] forState:UIControlStateNormal];
        
        button.userInteractionEnabled = NO;
        
        button.tag =i+1;
        
        [button setImage:[UIImage imageNamed:self.selectedImage] forState:UIControlStateSelected];
        
        [self addSubview:button];
    }
    
    
    
}

-(void)layoutSubviews
{
    
    //button 的位置在layoutSubviews设置比较准确
    
    [super layoutSubviews];
    
    CGFloat col = 0;
    CGFloat row = 0;
    
    CGFloat btnW = self.btnWidth;
    CGFloat btnH = self.btnWidth;
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    NSUInteger tolCol = 3;
    CGFloat margin = (self.bounds.size.width - tolCol*btnW)/(tolCol+1);
    
    for (int i = 0 ; i < 9; i ++) {
        
        col = i%3;
        row = i/3;
        btnX = margin +(margin +btnW)*col;//行
        
        btnY = (margin-10 +btnW)*row;//列
        
        UIButton *button =self.subviews[i];
        
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
    }
}

//获取触摸点的位置
- (CGPoint)pointWithTouches:(NSSet *)touches
{
    
    UITouch *touch =[touches anyObject];
    CGPoint pos = [touch locationInView:self];
    return pos;
}

- (UIButton *)buttonWithPoint:(CGPoint)point
{
    
    //只用按钮中心的30像素
    CGFloat wh = self.btnWidth/2;
    
    for (UIView *view in self.subviews) {
        UIButton *btn;
        if (view.tag > 0 && view.tag < 10) {
            btn = (UIButton *)view;
        }else{
            return nil;
        }
        CGFloat x = btn.center.x - wh*0.5;
        CGFloat y = btn.center.y - wh*0.5;
        CGRect frame = CGRectMake(x, y, wh, wh);
        if (CGRectContainsPoint(frame, point)) {
            return btn;
        }
    }
    return nil;
}
#pragma mark---touchesMoved 按着拖动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"2222222");
    CGPoint pos = [self pointWithTouches:touches];
    
    _moveP = pos;
    
    UIButton *button  =[self buttonWithPoint:pos];
    
    if (button&&button.selected==NO) {
        button.selected = YES;
        
        [_btns addObject:button];
    }
    //重绘
    [self setNeedsDisplay];
}
#pragma mark---touchesBegan 刚开始按下
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"1111111");

    CGPoint pos = [self pointWithTouches:touches];
    
    UIButton *button  =[self buttonWithPoint:pos];
    
    if (button&&button.selected==NO) {
        button.selected = YES;
        
        [_btns addObject:button];

    }
}
#pragma mark---touchesEnded  触摸结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"33333333");
    //1.取消所有按钮的选中
    [self.btns makeObjectsPerformSelector:@selector(setSelected:) withObject:@NO];
    
    NSMutableString *password = [NSMutableString string];
    
    for (UIButton *button in self.btns) {
        button.selected = NO;
        [password appendFormat:@"%ld",button.tag];
    }
    //回传密码
    self.callBackPassword(password);
    
    [self.btns removeAllObjects];
    
    [self setNeedsDisplay];
}
#pragma mark---drawRect
- (void)drawRect:(CGRect)rect
{
    if (!self.btns.count) return;
    
    UIBezierPath *path  =[UIBezierPath bezierPath];
    
    for (int i = 0; i <self.btns.count; i++) {
        
        UIButton *button  =_btns[i];
        if (i==0) {
            [path moveToPoint:button.center];
        } else {
            [path addLineToPoint:button.center];
        }
    }
    [path addLineToPoint:_moveP];
    
    [self.lineColor set];
    
    path.lineWidth =self.lineWidth;
    
    path.lineJoinStyle = kCGLineJoinMiter;
    
    [path stroke];
        
    
    
}


@end
