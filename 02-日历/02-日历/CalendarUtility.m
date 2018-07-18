//
//  CalendarUtility.m
//  02-日历
//
//  Created by vera on 16/4/21.
//  Copyright © 2016年 vera. All rights reserved.
//

#import "CalendarUtility.h"

@implementation CalendarUtility

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _calendar = [NSCalendar currentCalendar];
    }
    return self;
}

+ (CalendarUtility *)shareCalendar
{
    static CalendarUtility *shareCalendar = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCalendar = [[self alloc] init];
    });
    
    return shareCalendar;
}

@end
