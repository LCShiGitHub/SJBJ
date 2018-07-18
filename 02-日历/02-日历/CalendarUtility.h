//
//  CalendarUtility.h
//  02-日历
//
//  Created by vera on 16/4/21.
//  Copyright © 2016年 vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarUtility : NSObject

@property (nonatomic, strong) NSCalendar *calendar;

+ (CalendarUtility *)shareCalendar;

@end
