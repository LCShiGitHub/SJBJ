//
//  NSDate+Calendar.m
//  02-日历
//
//  Created by vera on 16/4/21.
//  Copyright © 2016年 vera. All rights reserved.
//

#import "NSDate+Calendar.h"
#import "CalendarUtility.h"

@implementation NSDate (Calendar)


- (NSDate *)lastDate
{
    NSCalendar *calendar = [CalendarUtility shareCalendar].calendar;
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:self];
    components.month -= 1;
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)nextDate
{
    NSCalendar *calendar = [CalendarUtility shareCalendar].calendar;
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:self];
    components.month += 1;
    
    return [calendar dateFromComponents:components];
}

- (NSInteger)dayFromMonth
{
    NSCalendar *calendar = [CalendarUtility shareCalendar].calendar;
    
    return [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}

- (NSInteger)monthFirstWeekDay
{
    NSCalendar *calendar = [CalendarUtility shareCalendar].calendar;
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    components.day = 1;
    
    NSDate *date = [calendar dateFromComponents:components];
    
    NSInteger n = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:date];
    
    
    return n - 1;
}

- (NSInteger)currentYear
{
    NSCalendar *calendar = [CalendarUtility shareCalendar].calendar;
    
    NSInteger year = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self].year;
    
    return year;
}

- (NSInteger)currentMonth;
{
    NSCalendar *calendar = [CalendarUtility shareCalendar].calendar;
    
    NSInteger month = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self].month;
    
    return month;
}

@end
