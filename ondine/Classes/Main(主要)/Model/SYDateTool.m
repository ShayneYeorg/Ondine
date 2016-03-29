//
//  DateTool.m
//  testTime
//
//  Created by 杨淳引 on 15/5/29.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

#import "SYDateTool.h"

@implementation SYDateTool

//长日期的格式
+ (NSDateFormatter *)formatterInit {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateStyle:NSDateFormatterMediumStyle];
    [fmt setTimeStyle:NSDateFormatterShortStyle];
    [fmt setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    fmt.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [fmt setTimeZone:timeZone];
    return fmt;
}

//短日期的格式，只有年月日
+ (NSDateFormatter *)shortFormatterInit {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateStyle:NSDateFormatterMediumStyle];
    [fmt setTimeStyle:NSDateFormatterShortStyle];
    [fmt setDateFormat:@"YYYY-MM-dd"];
    fmt.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [fmt setTimeZone:timeZone];
    return fmt;
}

+ (NSDate *)transTimeStampToDate:(NSString *)timeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp integerValue]];
    return date;
}

+ (NSString *)transDateToTimeStamp:(NSDate *)date {
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long int)[date timeIntervalSince1970]];
    return timeStamp;
}

/**
 *   这个方法用来将时间戳转化为长日期格式的日期NSString对象
 */
+ (NSString *)transTimeStampToString:(NSString *)timeStamp {
    NSDate *date = [self transTimeStampToDate:timeStamp];
    NSString *dateStr = [self transDateToString:date];
    return dateStr;
}

/**
 *   这个方法用来将NSDate转化为长日期格式的日期NSString对象
 */
+ (NSString *)transDateToString:(NSDate *)date {
    NSDateFormatter *fmt = [self formatterInit];
    NSString *dateStr = [fmt stringFromDate:date];
    return dateStr;
}

/**
 *   这个方法用来将NSDate转化为短日期格式的日期NSString对象
 */
+ (NSString *)transDateToShortString:(NSDate *)date {
    NSDateFormatter *fmt = [self shortFormatterInit];
    NSString *dateStr = [fmt stringFromDate:date];
    return dateStr;
}

/**
 *   这个方法用来将短日期格式的日期NSString对象转化为NSDate对象
 */
+ (NSDate *)transShortStringToDate:(NSString *)dateStr {
    NSDateFormatter *fmt = [self shortFormatterInit];
    NSDate *date = [fmt dateFromString:dateStr];
    return date;
}

/**
 *   取得某一天的精确开始时间，即是参数日期凌晨0点的时间戳
 */
+ (NSInteger)getStartTimeStampInADate:(NSDate *)date {
    NSInteger startTimeStamp;
    
    //将NSDate截断到剩只日期，再把它转化回NSDate格式，得到的结果默认就是这一天的开始时间
    NSString *strShortDate = [self transDateToShortString:date];
    NSDate *shortDate = [self transShortStringToDate:strShortDate];
    startTimeStamp = [[self transDateToTimeStamp:shortDate]integerValue];
    
    return startTimeStamp;
}

/**
 *   取得某一天的精确结束时间，即是参数日期晚上的24点0分0秒的时间戳
 */
+ (NSInteger)getEndTimeStampInADay:(NSDate *)date {
    NSInteger endTimeStamp;
    
    //取得这一天的开始时间，再加上86400秒（24小时）可得到这一天的结束时间
    NSInteger startTimeStamp = [self getStartTimeStampInADate:date];
    endTimeStamp = startTimeStamp + 86400;
    
    return endTimeStamp;
}

@end
