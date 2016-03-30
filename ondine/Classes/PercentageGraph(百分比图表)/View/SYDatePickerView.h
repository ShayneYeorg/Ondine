//
//  SYDatePickerView.h
//  ondine
//
//  Created by 杨淳引 on 15/6/1.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//
/**
 *   从下方弹出的日期选择页面
 */

#import <UIKit/UIKit.h>

@protocol SYDatePickerViewDelegate <NSObject>
-(void)datePickerViewDidClickConfirmBtn:(UIView *)view withDate:(NSDate *)date;
-(void)datePickerViewRefreshSuperView;
@end

@interface SYDatePickerView : UIView
@property (nonatomic, weak) id<SYDatePickerViewDelegate> delegate;
@end
