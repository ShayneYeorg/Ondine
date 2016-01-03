//
//  SYCountingTimeTool.m
//  ondine
//
//  Created by 杨淳引 on 15/5/31.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

#import "SYCountingTimeTool.h"

@implementation SYCountingTimeTool
/**
 *   把秒数转换成countingTime对象
 */
+(SYCountingTime *)transSecondsToCountingTime:(NSInteger)sec{
    SYCountingTime *countingTime = [[SYCountingTime alloc]init];
    countingTime.sec = sec % 60;
//    countingTime.min = ((sec - (sec % 60)) / 60) % 60;
    countingTime.min = ((sec - countingTime.sec) / 60) % 60;
//    countingTime.hur = (((sec - (sec % 60)) / 60) - (((sec - (sec % 60)) / 60) % 60)) / 60;
    countingTime.hur = (sec - countingTime.sec - (countingTime.min * 60)) / 60 / 60;
    return countingTime;
}

/**
 *   让countingTime对象一秒一秒地增加上去的方法
 */
+(SYCountingTime *)countingTimePlus:(SYCountingTime *)countingTime{
    if (countingTime.sec < 59) {
        countingTime.sec += 1;
    }else{
        countingTime.sec = 0;
        if (countingTime.min < 59) {
            countingTime.min += 1;
        }else{
            countingTime.min = 0;
            countingTime.hur += 1;
        }
    }
    return countingTime;
}

/**
 *   把一个NSString类型的hh:mm:ss格式时间转化成SYCountingTime类型的实例的方法
 */
+(SYCountingTime *)transStringToCountingTime:(NSString *)timeStr{
    SYCountingTime *countTime = [[SYCountingTime alloc]init];
    NSRange firstColonRange = [timeStr rangeOfString:@":"];
    if (firstColonRange.length == 0) {
        return countTime;
    }
    //小时的range
    NSRange hourRange;
    hourRange.location = 0;
    hourRange.length = firstColonRange.location;
    countTime.hur = [[timeStr substringWithRange:hourRange]integerValue];
    //分钟的range
    NSRange minRange;
    minRange.location = firstColonRange.location + 1;
    minRange.length = 2;
    countTime.min = [[timeStr substringWithRange:minRange]integerValue];
    //秒的range
    NSRange secRange;
    secRange.location = firstColonRange.location + 4;
    secRange.length = 2;
    countTime.sec = [[timeStr substringWithRange:secRange]integerValue];
    return countTime;
}

@end













