//
//  TimeTool.m
//  testTime
//
//  Created by 杨淳引 on 15/5/29.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//
/**
 *   在这个类里建立了两张数据库表，分别是t_time事件流水表和t_currentEvent当前事件表：
 *   t_time事件流水表：这张表会按时间顺序记录下所有发生的事件，包含了5个字段：timeId(流水ID), eventId(发生事件的ID), startTime(开始时间), endTime(结束时间), duration(历时)
 *   t_currentEvent当前事件表，这张表会记录下当前正在执行的事件，如果没有正在执行的事件，会将currentEventId设置为0（无对应事件存在），这张表包含了3个字段：tableId(主键), currentEventId(当前执行的事件的ID), urrentEvent(标识符，查询时使用)
 */

#import "SYTimeTool.h"
#import "FMDB.h"
#import "SYDateTool.h"

@implementation SYTimeTool

//数据库对象
static FMDatabase *_db;

+ (void)initialize {
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ondine.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_time (timeId integer PRIMARY KEY, eventId integer NOT NULL, startTime integer NOT NULL, endTime integer, duration integer);"];
    //currentEventId存的是当前在执行的事件，在t_time表里的流水编号
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_currentEvent (tableId integer PRIMARY KEY, currentEventId integer NOT NULL, urrentEvent text NOT NULL);"];
    
    FMResultSet *set = [_db executeQuery:@"SELECT * from t_currentEvent;"];
    if(!set.next){
        [_db executeUpdate:@"INSERT INTO t_currentEvent(currentEventId, urrentEvent) VALUES (0, 'urrentEvent');"];
    }
}

+ (NSString *)getCurrentEventName {
    NSString *currentEventName = [[NSString alloc]init];
    NSInteger currentTimeId = [self getCurrentTimeId];
    NSInteger currentEventId = -1;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT eventId FROM t_time WHERE timeId = %ld;", (long)currentTimeId];
    while (set.next) {
        currentEventId = [set intForColumn:@"eventId"];
        FMResultSet *set2 = [_db executeQueryWithFormat:@"SELECT eventName FROM t_event WHERE eventId = %ld;", (long)currentEventId];
        while (set2.next) {
            currentEventName = [set2 stringForColumn:@"eventName"];
        }
    }
    return currentEventName;
}

/**
 *   update t_currentEvent里面的当前事件ID
 */
+ (void)updateCurrentTimeId:(NSInteger)timeId {
    [_db executeUpdateWithFormat:@"UPDATE t_currentEvent SET currentEventId = %ld WHERE urrentEvent = 'urrentEvent';", (long)timeId];
}

/**
 *   取得t_currentEvent表里的当前事件ID，即是取得系统当前正在执行的事件
 */
+ (NSInteger)getCurrentTimeId {
    NSInteger currentTimeId = -1;
    FMResultSet *set = [_db executeQuery:@"SELECT currentEventId FROM t_currentEvent WHERE urrentEvent = 'urrentEvent';"];
    while (set.next) {
        currentTimeId = [set intForColumn:@"currentEventId"];
    }
    return currentTimeId;
}

/**
 *   事件开始时调用，插入执行的事件和开始执行的时间并返回事件在t_time表中的流水编号
 */
+ (NSInteger)insertStartTime:(NSDate *)startTime withEvent:(NSInteger)eventId {
    NSString *timeStamp = [SYDateTool transDateToTimeStamp:startTime];
    [_db executeUpdateWithFormat:@"INSERT INTO t_time(eventId, startTime) VALUES (%ld, %@);", (long)eventId, timeStamp];
    NSInteger topId = -1;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT timeId FROM t_time WHERE startTime = %@ and eventId = %ld;",timeStamp, (long)eventId];
    while (set.next) {
        topId = [set intForColumn:@"timeId"];
    }
    return topId;
}

+ (NSDate *)getTopStartTime {
    NSDate *topStartTime = [[NSDate alloc]init];
    FMResultSet *set = [_db executeQuery:@"SELECT startTime FROM t_time ORDER BY timeId DESC LIMIT 0,1;"];
    while (set.next) {
        NSString *timeStamp = [set stringForColumn:@"startTime"];
        topStartTime = [SYDateTool transTimeStampToDate:timeStamp];
    }
    return topStartTime;
}

+ (NSString *)getTopStartTimeString {
    NSString *topStartTimeSring = [[NSString alloc]init];
    FMResultSet *set = [_db executeQuery:@"SELECT startTime FROM t_time ORDER BY timeId DESC LIMIT 0,1;"];
    while (set.next) {
        NSString *timeStamp = [set stringForColumn:@"startTime"];
        topStartTimeSring = [SYDateTool transTimeStampToString:timeStamp];
    }
    return topStartTimeSring;
}

+ (NSInteger)getTopStartTimeStamp {
    NSInteger topStartTimeStamp = 0;
    FMResultSet *set = [_db executeQuery:@"SELECT startTime FROM t_time ORDER BY timeId DESC LIMIT 0,1;"];
    while (set.next) {
        NSString *timeStamp = [set stringForColumn:@"startTime"];
        topStartTimeStamp = [timeStamp integerValue];
    }
    return (long)topStartTimeStamp;
}

//这个才是最有用的
+ (NSInteger)getStartTimeStampByTimeId:(NSInteger)timeId {
    NSInteger startTimeStamp = 0;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT startTime FROM t_time WHERE timeId = %ld;", (long)timeId];
    while (set.next) {
        NSString *timeStamp = [set stringForColumn:@"startTime"];
        startTimeStamp = [timeStamp integerValue];
    }
    return (long)startTimeStamp;
}

/**
 *   事件结束时调用，插入执行的事件和结束执行的时间
 */
+ (void)updateEndTime:(NSDate *)endTime withTimeId:(NSInteger)timeId {
    NSString *endTimeString = [[NSString alloc]init];
    endTimeString = [SYDateTool transDateToTimeStamp:endTime];
    [_db executeUpdateWithFormat:@"UPDATE t_time SET endTime = %@ WHERE timeId = %ld;", endTimeString, (long)timeId];
}

+(NSDate *)getTopEndTime {
    NSDate *topEndTime = [[NSDate alloc]init];
    FMResultSet *set = [_db executeQuery:@"SELECT endTime FROM t_time ORDER BY timeId DESC LIMIT 0,1;"];
    while (set.next) {
        NSString *topEndTimeString = [set stringForColumn:@"endTime"];
        topEndTime = [SYDateTool transTimeStampToDate:topEndTimeString];
    }
    return topEndTime;
}

+ (NSString *)getTopEndTimeString {
    NSString *topEndTime = [[NSString alloc]init];
    FMResultSet *set = [_db executeQuery:@"SELECT endTime FROM t_time ORDER BY timeId DESC LIMIT 0,1;"];
    while (set.next) {
        NSString *topEndTimeString = [set stringForColumn:@"endTime"];
        topEndTime = [SYDateTool transTimeStampToString:topEndTimeString];
    }
    return topEndTime;
}

+ (NSInteger)getTopEndTimeStamp {
    NSInteger topEndTimeStamp = 0;
    FMResultSet *set = [_db executeQuery:@"SELECT endTime FROM t_time ORDER BY timeId DESC LIMIT 0,1;"];
    while (set.next) {
        NSString *topEndTimeString = [set stringForColumn:@"endTime"];
        topEndTimeStamp = [topEndTimeString integerValue];
    }
    return topEndTimeStamp;
}

//这个才是有用的
+ (NSInteger)getEndTimeStampByTimeId:(NSInteger)timeId {
    NSInteger endTimeStamp = 0;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT endTime FROM t_time WHERE timeId = %ld;", (long)timeId];
    while (set.next) {
        NSString *topEndTimeString = [set stringForColumn:@"endTime"];
        endTimeStamp = [topEndTimeString integerValue];
    }
    return endTimeStamp;
}

+ (NSInteger)getTopId {
    NSInteger topId = -1;
    FMResultSet *set = [_db executeQuery:@"SELECT top timeId FROM t_time;"];
    while (set.next) {
        topId = [set intForColumn:@"timeId"];
    }
    return topId;
}

//插入事件经历时长
+ (void)insertDuration:(NSInteger)duration withTimeId:(NSInteger)timeId {
    [_db executeUpdateWithFormat:@"UPDATE t_time SET duration = %ld WHERE timeId = %ld;", (long)duration, (long)timeId];
}
@end






