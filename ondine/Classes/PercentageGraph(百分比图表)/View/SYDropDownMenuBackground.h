//
//  SYDropDownMenuBackground.h
//  ondine
//
//  Created by 杨淳引 on 15/6/3.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//
//  这个类是下拉框背后的透明蒙板

#import <UIKit/UIKit.h>

@interface SYDropDownMenuBackground : UIView
+ (instancetype)menu;
- (void)showFrom:(UIView *)from;
- (void)dismiss;

/**
 *  下拉框里的内容的controller
 */
@property (nonatomic, strong) UIViewController *contentController;

/**
 *  这个属性用来指定下拉框里的内容，即是这个下拉控件里的UIView
 */
@property (nonatomic, strong) UIView *content;

@end
