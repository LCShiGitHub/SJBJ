//
//  CalendarView.m
//  02-日历
//
//  Created by vera on 16/4/21.
//  Copyright © 2016年 vera. All rights reserved.
//

#import "CalendarView.h"
#import "CalendarConfig.h"
#import "CalendarPageView.h"
#import "NSDate+Calendar.h"

#define kSpace 0

#define kYSpace 30
#define kWeekdayLabelHeight 30

@interface CalendarView ()

@property (nonatomic, strong) NSArray *weekdays;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) CalendarPageView *currentCalendarPageView;
@property (nonatomic, weak) UILabel *currenMonthLabel;

@property (nonatomic, strong) NSDate *currentDate;

@end

@implementation CalendarView

- (CalendarPageView *)currentCalendarPageView
{
    if (!_currentCalendarPageView)
    {
        CalendarPageView *currentCalendarPageView = [[CalendarPageView alloc] init];
        [_scrollView addSubview:currentCalendarPageView];
        
        _currentCalendarPageView = currentCalendarPageView;
    }
    
    return _currentCalendarPageView;
}

- (UILabel *)currenMonthLabel
{
    if (!_currenMonthLabel)
    {
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        [self addSubview:l];
        
        _currenMonthLabel = l;
    }
    
    return _currenMonthLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _weekdays = @[@"SUN",@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT"];
    
    self.currentDate = [NSDate date];
    
    
    for (int i = 0; i < _weekdays.count; i++)
    {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        weekdayLabel.text = _weekdays[i];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.font = [UIFont systemFontOfSize:13];
        weekdayLabel.textColor = [UIColor lightGrayColor];
        weekdayLabel.tag = i + 1;
        [self addSubview:weekdayLabel];
    }
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    
    self.currenMonthLabel.text = [NSString stringWithFormat:@"%ld年%ld月",[NSDate date].currentYear,[NSDate date].currentMonth];
    
    UIButton *proButton = [UIButton buttonWithType:UIButtonTypeCustom];
    proButton.frame = CGRectMake(kSpace, 0, 60, 30);
    proButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [proButton setTitle:@"上月" forState:UIControlStateNormal];
    proButton.backgroundColor = [UIColor redColor];
    [proButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [proButton addTarget:self action:@selector(proButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:proButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(kMainScreenWidth - kSpace - 60, 0, 60, 30);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setTitle:@"下月" forState:UIControlStateNormal];
    nextButton.backgroundColor = [UIColor redColor];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextButton];
}

#pragma mark - 上个月
- (void)proButtonClick
{
    NSDate *date = [self.currentDate lastDate];
    
    [self.currentCalendarPageView reloadDateWithDate:date];
    
    self.currentDate = date;
    
    self.currenMonthLabel.text = [NSString stringWithFormat:@"%ld年%ld月",date.currentYear,date.currentMonth];
}

#pragma mark - 下个月
- (void)nextButtonClick
{
    NSDate *date = [self.currentDate nextDate];
    
    [self.currentCalendarPageView reloadDateWithDate:date];
    
    self.currentDate = date;
    
    self.currenMonthLabel.text = [NSString stringWithFormat:@"%ld年%ld月",date.currentYear,date.currentMonth];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat weekdayLabelWidth = (kMainScreenWidth - 2*kSpace)/_weekdays.count;
    
    for (int i = 0; i < _weekdays.count; i++)
    {
        UILabel *l = (UILabel *)[self viewWithTag:i + 1];
        l.frame = CGRectMake(kSpace + weekdayLabelWidth * i, kYSpace, weekdayLabelWidth, kWeekdayLabelHeight);
    }
    
    _scrollView.frame = CGRectMake(kSpace, kYSpace + kWeekdayLabelHeight, kMainScreenWidth - 2*kSpace, self.frame.size.height - kYSpace - kWeekdayLabelHeight);
    
    
    self.currentCalendarPageView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    
    self.currenMonthLabel.frame = CGRectMake(0, 0, kMainScreenWidth, 30);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
