//
//  SYPcRectGraph.h
//  ondine
//
//  Created by 杨淳引 on 15/6/2.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//
/**
 *   百分比图形的模型类
 */

#import <Foundation/Foundation.h>

@interface SYPcRectGraph : NSObject
@property (nonatomic, copy) NSString *graphName;
@property (nonatomic, assign) NSInteger graphColorR;
@property (nonatomic, assign) NSInteger graphColorG;
@property (nonatomic, assign) NSInteger graphColorB;
@property (nonatomic, assign) NSInteger duration;
@end
