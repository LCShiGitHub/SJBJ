//
//  CalendarPageView.m
//  02-日历
//
//  Created by vera on 16/4/21.
//  Copyright © 2016年 vera. All rights reserved.
//

#import "CalendarPageView.h"
#import "CalendarConfig.h"
#import "NSDate+Calendar.h"

#define kDay 42
#define kRow 6
#define kColumn 7

#define kButtonWidth kMainScreenWidth/kColumn
#define kButtonHeight kButtonWidth - 20

@interface CalendarPageView ()

@end

@implementation CalendarPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSInteger firstDay = [NSDate date].monthFirstWeekDay;
        NSInteger days = [NSDate date].dayFromMonth;
        
        for (NSInteger i = firstDay; i < days + firstDay; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
            [btn setTitle:[NSString stringWithFormat:@"%ld",(i - firstDay + 1)] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.tag = i + 1;
            [self addSubview:btn];
        }
        
    }
    return self;
}

- (void)reloadDateWithDate:(NSDate *)date
{
    for (UIView *subview in self.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            [subview removeFromSuperview];
        }
    }
    
    //刷新指定日期的日历
    NSInteger firstDay = date.monthFirstWeekDay;
    NSInteger days = date.dayFromMonth;
    
    for (NSInteger i = firstDay; i < days + firstDay; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i%kColumn*kButtonWidth, i/kColumn * kButtonHeight + 30, kButtonWidth, kButtonHeight);
        btn.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
        [btn setTitle:[NSString stringWithFormat:@"%ld",(i - firstDay + 1)] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i + 1;
        [self addSubview:btn];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    
    NSInteger firstDay = [NSDate date].monthFirstWeekDay;
    NSInteger days = [NSDate date].dayFromMonth;
    
    for (NSInteger i = firstDay; i < days + firstDay; i++)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:i + 1];
        btn.frame = CGRectMake(i%kColumn*kButtonWidth , i/kColumn * kButtonHeight + 30, kButtonWidth, kButtonHeight);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
