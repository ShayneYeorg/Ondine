//
//  SYPcRectGraphTool.h
//  ondine
//
//  Created by 杨淳引 on 15/6/2.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//
/**
 *   百分比图形的实例的工具类
 */

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "SYPcRectGraph.h"

@interface SYPcRectGraphTool : NSObject
+(NSMutableArray *)pcRectGraphesWithStartTimeStamp:(NSInteger)startTimeStamp andEndTimeStamp:(NSInteger)endTimeStamp;
@end
