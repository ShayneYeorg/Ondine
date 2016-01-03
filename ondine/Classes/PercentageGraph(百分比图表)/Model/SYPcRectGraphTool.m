//
//  SYPcRectGraphTool.m
//  ondine
//
//  Created by 杨淳引 on 15/6/2.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//
/**
 *   这个工具类里新建了一张t_color颜色表，存放了系统提供的所有颜色的RGB数值：
 *   colorId(主键), colorName(颜色名称), colorR, colorG, colorB
 */

#import "SYPcRectGraphTool.h"
#import "SYEventTool.h"

@implementation SYPcRectGraphTool
//数据库对象
static FMDatabase *_db;

+ (void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ondine.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 2.创建颜色对应表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_color (colorId integer PRIMARY KEY, colorName text NOT NULL UNIQUE, colorR integer NOT NULL, colorG integer NOT NULL, colorB integer NOT NULL);"];
    FMResultSet *set = [_db executeQuery:@"SELECT * from t_color;"];
    if(!set.next){
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_white', 255, 255, 255);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_black', 0, 0, 0);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_red', 250, 0, 0);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_red2', 250, 68, 72);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_red3', 197, 5, 9);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_red4', 166, 4, 4);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_pink', 252, 122, 122);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_pink2', 252, 172, 174);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_purple', 139, 2, 137);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_purple2', 188, 4, 186);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_purple3', 241, 2, 238);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_blue', 16, 4, 134);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_blue2', 22, 4, 193);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_blue3', 26, 3, 250);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_wathet', 7, 136, 210);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_wathet2', 11, 161, 248);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_wathet3', 115, 203, 253);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_reseda', 1, 173, 147);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_reseda2', 5, 233, 198);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_reseda3', 135, 253, 235);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_green', 10, 109, 2);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_green2', 14, 152, 4);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_green3', 17, 205, 2);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_green4', 23, 252, 6);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_yellow', 223, 215, 4);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_yellow2', 251, 242, 5);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_yellow3', 252, 247, 115);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_yellow4', 249, 247, 186);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_brown', 124, 69, 4);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_brown2', 176, 97, 3);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_brown3', 248, 136, 3);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_orange', 255, 97, 0);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_orange2', 249, 124, 48);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_orange3', 253, 158, 99);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_gray', 94, 92, 91);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_gray2', 149, 147, 147);"];
        [_db executeUpdate:@"INSERT INTO t_color(colorName, colorR, colorG, colorB) VALUES ('event_gray3', 196, 195, 195);"];
    }
}

/**
 *   这个方法会根据提供的两个时间戳去查询对应时间内的所有信息，然后打包成SYPcRectGraph对象组成的数组返回
 */
+(NSMutableArray *)pcRectGraphesWithStartTimeStamp:(NSInteger)startTimeStamp andEndTimeStamp:(NSInteger)endTimeStamp{
    //1、建立各个存放对象
    //用来返回的可变数组
    NSMutableArray *arrayM = [NSMutableArray array];
    //用来存放查询出来的eventId，其他的数据都是根据它来做二次查询的
    NSString *eventId = [[NSString alloc]init];
    //来存放查询出来的eventColor，RGB数据是根据它来做二次查询的
    NSString *evenColor = [[NSString alloc]init];
    
    //2、取得在时间段内发生的所有事件ID的数组
    NSArray *arrayEvents = [self getEventNamesWithStartTimeStamp:startTimeStamp andEndTimeStamp:endTimeStamp];
    for(int n = 0; n < arrayEvents.count; n++){
        SYPcRectGraph *graph = [[SYPcRectGraph alloc]init];
        //取出事件ID
        eventId = arrayEvents[n];
        //根据事件ID取事件名称
        graph.graphName = [SYEventTool getEventNameByStrEventId:eventId];
        //根据事件ID取事件总时长
        graph.duration = [self getDurationWithEventId:eventId duringStartTimeStamp:startTimeStamp andEndTimeStamp:endTimeStamp];
        //根据事件ID取事件代表颜色
        evenColor = [SYEventTool getEventColorByStrEventId:eventId];
        graph.graphColorR = [self getRColorByColorName:evenColor];
        graph.graphColorG = [self getGColorByColorName:evenColor];
        graph.graphColorB = [self getBColorByColorName:evenColor];
        //打包进数组里
        [arrayM addObject:graph];
    }
    return arrayM;
}

/**
 *   查找出参数时间段内的事件的名称
 */
+(NSArray *)getEventNamesWithStartTimeStamp:(NSInteger)startTimeStamp andEndTimeStamp:(NSInteger)endTimeStamp{
    NSMutableArray *arrayM = [NSMutableArray array];
    
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT DISTINCT eventId FROM t_time WHERE (startTime > %ld AND endTime < %ld) OR (startTime < %ld AND endTime > %ld) OR (startTime < %ld AND endTime > %ld)", (long)startTimeStamp, (long)endTimeStamp, (long)startTimeStamp, (long)startTimeStamp, (long)endTimeStamp, (long)endTimeStamp];
    while (set.next) {
        NSString *eventId = [set stringForColumn:@"eventId"];
        [arrayM addObject:eventId];
    }
    
    return arrayM;
}

/**
 *   根据事件名称和时间段，查找出事件的总发生时长
 */
+(NSInteger)getDurationWithEventId:(NSString *)eventId duringStartTimeStamp:(NSInteger)startTimeStamp andEndTimeStamp:(NSInteger)endTimeStamp{
    NSInteger duration = 0;
    
    //分4种情况来处理：1、事件的开始和结束时间都在查询时间内
    FMResultSet *set1 = [_db executeQueryWithFormat:@"SELECT sum(duration) AS sumDuration FROM t_time WHERE eventId = %@ AND (startTime > %ld AND endTime < %ld);", eventId, (long)startTimeStamp, (long)endTimeStamp];
    while (set1.next) {
        duration += [set1 intForColumn:@"sumDuration"];
    }
    //2、事件的开始时间在查询时间前，但结束时间在查询时间内
    FMResultSet *set2 = [_db executeQueryWithFormat:@"SELECT endTime FROM t_time WHERE eventId = %@ AND (startTime < %ld) AND (endTime BETWEEN %ld AND %ld);", eventId, (long)startTimeStamp, (long)startTimeStamp, (long)endTimeStamp];
    while (set2.next) {
        duration += ([set2 intForColumn:@"endTime"] - startTimeStamp);
    }
    //3、事件的开始时间在查询时间内，但是结束时间在查询时间后
    FMResultSet *set3 = [_db executeQueryWithFormat:@"SELECT startTime FROM t_time WHERE eventId = %@ AND (startTime BETWEEN %ld AND %ld) AND (endTime > %ld);", eventId, (long)startTimeStamp, (long)endTimeStamp, (long)endTimeStamp];
    while (set3.next) {
        duration += (endTimeStamp - [set3 intForColumn:@"startTime"]);
    }
    //4、事件的延续时间大于查询时间
    FMResultSet *set4 = [_db executeQueryWithFormat:@"SELECT startTime FROM t_time WHERE eventId = %@ AND (startTime < %ld AND endTime > %ld);", eventId, (long)startTimeStamp, (long)endTimeStamp];
    while (set4.next) {
        duration += (endTimeStamp - startTimeStamp);
    }
    
    return duration;
}

//以下3个方法通过colorName在t_color表里分别查询出colorName对应的RGB值
+(NSInteger)getRColorByColorName:(NSString *)color{
    NSInteger colorNum = 0;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT colorR FROM t_color WHERE colorName = %@;", color];
    while (set.next) {
        colorNum = [set intForColumn:@"colorR"];
    }
    return colorNum;
}

+(NSInteger)getGColorByColorName:(NSString *)color{
    NSInteger colorNum = 0;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT colorG FROM t_color WHERE colorName = %@;", color];
    while (set.next) {
        colorNum = [set intForColumn:@"colorG"];
    }
    return colorNum;
}

+(NSInteger)getBColorByColorName:(NSString *)color{
    NSInteger colorNum = 0;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT colorB FROM t_color WHERE colorName = %@;", color];
    while (set.next) {
        colorNum = [set intForColumn:@"colorB"];
    }
    return colorNum;
}

@end
