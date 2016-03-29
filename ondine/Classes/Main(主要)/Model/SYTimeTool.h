//
//  TimeTool.h
//  testTime
//
//  Created by 杨淳引 on 15/5/29.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//
/**
 *   这个工具类用来处理事件计时任务和数据库的交互
 */

#import <Foundation/Foundation.h>

@interface SYTimeTool : NSObject

//和当前正在进行的事件有关的方法
+ (NSString *)getCurrentEventName;
+ (void)updateCurrentTimeId:(NSInteger)eventId;
+ (NSInteger)getCurrentTimeId;

//和事件开始时间有关的方法
+ (NSInteger)insertStartTime:(NSDate *)startTime withEvent:(NSInteger)eventId;
+ (NSDate *)getTopStartTime;
+ (NSString *)getTopStartTimeString;
+ (NSInteger)getTopStartTimeStamp;
+ (NSInteger)getStartTimeStampByTimeId:(NSInteger)timeId;

//和事件结束时间有关的方法
+ (void)updateEndTime:(NSDate *)endTime withTimeId:(NSInteger)timeId;
+ (NSDate *)getTopEndTime;
+ (NSString *)getTopEndTimeString;
+ (NSInteger)getTopEndTimeStamp;
+ (NSInteger)getEndTimeStampByTimeId:(NSInteger)timeId;

//和事件时长有关的方法
+ (void)insertDuration:(NSInteger)duration withTimeId:(NSInteger)timeId;

//现在没什么鸟用，以后可能会有用的其他方法
+ (NSInteger)getTopId;

@end




