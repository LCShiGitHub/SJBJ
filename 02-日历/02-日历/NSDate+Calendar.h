//
//  NSDate+Calendar.h
//  02-日历
//
//  Created by vera on 16/4/21.
//  Copyright © 2016年 vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Calendar)

/**
 *  上月日期
 *
 *  @return <#return value description#>
 */
- (NSDate *)lastDate;

/**
 *  下月日期
 *
 *  @return <#return value description#>
 */
- (NSDate *)nextDate;

/**
 *  当前月有多少天
 *
 *  @return <#return value description#>
 */
- (NSInteger)dayFromMonth;

/**
 *  这个月第一天是星期几
 *
 *  @return <#return value description#>
 */
- (NSInteger)monthFirstWeekDay;

/**
 *  当前的月份
 *
 *  @return <#return value description#>
 */
- (NSInteger)currentYear;

/**
 *  当前年份
 *
 *  @return <#return value description#>
 */
- (NSInteger)currentMonth;


@end
