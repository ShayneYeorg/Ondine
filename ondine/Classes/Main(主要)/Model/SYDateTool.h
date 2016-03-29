//
//  DateTool.h
//  testTime
//
//  Created by 杨淳引 on 15/5/29.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//
/**
 *   这个工具类用来处理NSDate和时间戳的转换，和NSDate和常见格式的日期的转换，
 *   其中时间戳提供了NSInteger和NSString两种类型
 */

#import <Foundation/Foundation.h>

@interface SYDateTool : NSObject

//NSDate和时间戳的转换
+ (NSString *)transDateToTimeStamp:(NSDate *)date;
+ (NSDate *)transTimeStampToDate:(NSString *)timeStamp;
+ (NSString *)transTimeStampToString:(NSString *)timeStamp;

//NSDate和常见格式的日期（NSString）的转换
+ (NSString *)transDateToString:(NSDate *)date;
+ (NSString *)transDateToShortString:(NSDate *)date;
+ (NSDate *)transShortStringToDate:(NSString *)dateStr;

//取得一个NSDate的开始时间和结束时间
+ (NSInteger)getStartTimeStampInADate:(NSDate *)date;
+ (NSInteger)getEndTimeStampInADay:(NSDate *)date;

@end
