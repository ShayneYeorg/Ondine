//
//  SYBtmSubView.h
//  ondine
//
//  Created by 杨淳引 on 15/5/25.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//
/**
 *   下方弹出框
 */

#import <UIKit/UIKit.h>
#import "SYEvent.h"
#import "SYEventTool.h"
#import "SYTimeTool.h"

@protocol SYBtmSubViewDelegate <NSObject>
-(void)btmSubViewDidClickQuitBtn:(UIView *)view;
@end

@interface SYBtmSubView : UIView
@property (nonatomic, weak) id<SYBtmSubViewDelegate> delegate;
-(void)quitView;

@end
