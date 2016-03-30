//
//  SYDatePickerBgView.h
//  ondine
//
//  Created by 杨淳引 on 15/6/1.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//
/**
 *   这个类是下方弹出的日期选择页面的蒙板
 */

#import <UIKit/UIKit.h>
#import "SYDatePickerView.h"

@interface SYDatePickerBgView : UIView
/**
 *   下方弹出的日期选择页面
 */
@property (nonatomic, strong) SYDatePickerView *dpView;
-(void)quitView;
@end
