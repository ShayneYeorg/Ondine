//
//  SYEventTool.m
//  ondine
//
//  Created by 杨淳引 on 15/5/26.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//
/**
 *   这个类会建立一张t_event事件表，用来存放所有的事件类型：
 *   它包含了个字段：eventId(事件ID), eventName(事件名称), eventColor(事件代表色)
 */

#import "SYEventTool.h"
#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "SYEvent.h"

@implementation SYEventTool

//数据库对象
static FMDatabase *_db;

+ (void)initialize {
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ondine.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_event (eventId integer PRIMARY KEY, eventName text NOT NULL UNIQUE, eventColor text NOT NULL);"];
    
    FMResultSet *set = [_db executeQuery:@"SELECT * from t_event WHERE eventName = '休息' OR eventName = '睡觉';"];
    if(!set.next){
        [_db executeUpdate:@"INSERT INTO t_event(eventId, eventName, eventColor) VALUES (1, '休息', 'event_white');"];
        [_db executeUpdate:@"INSERT INTO t_event(eventId, eventName, eventColor) VALUES (2, '睡觉', 'event_black');"];
    }
}

+ (void)addEvent:(SYEvent *)event {
    [_db executeUpdateWithFormat:@"INSERT INTO t_event(eventName, eventColor) VALUES (%@, %@);", event.eventName, event.eventColor];
}

//这个方法返回了一个数组，包含了t_event表里出了休息之外所有的事件
+ (NSArray *)events {
    NSMutableArray *events = [NSMutableArray array];
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_event;"];
    while (set.next) {
        SYEvent *event = [[SYEvent alloc] init];
        event.eventName = [set stringForColumn:@"eventName"];
        event.eventColor = [set stringForColumn:@"eventColor"];
        if(![event.eventName isEqualToString:@"休息"]){
            [events addObject:event];
        }
    }
    return events;
}

+ (BOOL)isExist:(SYEvent *)event {
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * from t_event WHERE eventName = %@;", event.eventName];
    if(set.next) {
        return YES;
    }
    return NO;
}

+ (NSInteger)getEventIdByEventName:(NSString *)eventName {
    NSInteger eventId = -1;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT eventId from t_event WHERE eventName = %@;", eventName];
    while (set.next) {
        eventId = [set intForColumn:@"eventId"];
    }
    return eventId;
}

+ (NSString *)getEventNameByStrEventId:(NSString *)eventId {
    NSString *eventName = [[NSString alloc]init];
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT eventName from t_event WHERE eventId = %@;", eventId];
    while (set.next) {
        eventName = [set stringForColumn: @"eventName"];
    }
    return eventName;
}


+ (NSString *)getEventColorByStrEventId:(NSString *)eventId {
    NSString *eventColor = [[NSString alloc]init];
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT eventColor from t_event WHERE eventId = %@;", eventId];
    while (set.next) {
        eventColor = [set stringForColumn: @"eventColor"];
    }
    return eventColor;
}

@end
