//
//  SYPcGraphView.h
//  ondine
//
//  Created by 杨淳引 on 15/6/1.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPcRectGraphTool.h"
#import "SYDropDownMenuBackground.h"
#import "SYDropDownMenuController.h"

@interface SYPcGraphView : UIScrollView
-(void)drawGraphWithStartTimeStamp:(NSInteger)startTimeStamp endTimeStamp:(NSInteger)endTimeStamp;
@end
