//
//  SYEventTool.h
//  ondine
//
//  Created by 杨淳引 on 15/5/26.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//
/**
 *   对事件模型进行操作和查询的工具类
 */

@class SYEvent;

#import <UIKit/UIKit.h>

@interface SYEventTool : NSObject

//事件操作方法
+ (NSArray *)events;
+ (void)addEvent:(SYEvent *)event;

//事件查询方法
+ (BOOL)isExist:(SYEvent *)event;
+ (NSInteger)getEventIdByEventName:(NSString *)eventName;
+ (NSString *)getEventNameByStrEventId:(NSString *)eventId;
+ (NSString *)getEventColorByStrEventId:(NSString *)eventId;

@end
