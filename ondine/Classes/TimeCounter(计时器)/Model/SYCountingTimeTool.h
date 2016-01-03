//
//  SYCountingTimeTool.h
//  ondine
//
//  Created by 杨淳引 on 15/5/31.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//
/**
 *   对SYCountingTime类对象的操作类
 */

#import <Foundation/Foundation.h>
#import "SYCountingTime.h"

@interface SYCountingTimeTool : NSObject
+(SYCountingTime *)transSecondsToCountingTime:(NSInteger)sec;
+(SYCountingTime *)countingTimePlus:(SYCountingTime *)countingTime;
+(SYCountingTime *)transStringToCountingTime:(NSString *)timeStr;
@end