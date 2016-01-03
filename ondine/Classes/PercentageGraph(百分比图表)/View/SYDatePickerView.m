//
//  SYDatePickerView.m
//  ondine
//
//  Created by 杨淳引 on 15/6/1.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

#import "SYDatePickerView.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kPickerViewWidth [UIScreen mainScreen].bounds.size.width
#define kPickerViewHeight (10 + self.picker.height + 20 + self.confirmBtn.height + 20)
#define kPickerY 10
#define kBtnY (10 + self.picker.height + 20)

@interface SYDatePickerView()
/**
 *   日期选择控件IDatePicker对象
 */
@property (nonatomic, strong) UIDatePicker *picker;

/**
 *   确定按钮
 */
@property (nonatomic, strong) UIButton *confirmBtn;
@end

@implementation SYDatePickerView
-(UIButton *)confirmBtn{
    if (_confirmBtn == nil) {
        UIButton *b = [[UIButton alloc]init];
        [b setBackgroundImage:[UIImage imageNamed:@"commitButton"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"commitButton_selected"] forState:UIControlStateHighlighted];
        b.width = 250; //固定宽高
        b.height = 50;
        b.centerX = self.centerX;
        b.y = kBtnY;
        [b addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn = b;
    }
    return _confirmBtn;
}

-(UIDatePicker *)picker{
    if (_picker == nil) {
        UIDatePicker *p = [[UIDatePicker alloc]init];
        p.datePickerMode = UIDatePickerModeDate;
        p.y = kPickerY;
        _picker = p;
    }
    return _picker;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self detailsOfInitWithFrame];
    }
    return self;
}

/**
 *   把initWithFrame:方法的具体加载内容整合在这个方法里
 */
-(void)detailsOfInitWithFrame{
    self.backgroundColor = [UIColor whiteColor];
    
    self.width = kPickerViewWidth;
    self.height = kPickerViewHeight;
    self.x = 0;
    self.y =  kScreenHeight * 0.99;
    
    [self addSubview:self.picker];
    [self addSubview:self.confirmBtn];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.y = (kScreenHeight - kPickerViewHeight);
    } completion:^(BOOL finished) {
    }];
}

-(void)confirmClick{
    NSDate *selectedDate = [self.picker date];
    if ([self.delegate respondsToSelector:@selector(datePickerViewDidClickConfirmBtn: withDate:)]) {
        [self.delegate datePickerViewDidClickConfirmBtn:self withDate:selectedDate];
    }
    if ([self.delegate respondsToSelector:@selector(datePickerViewRefreshSuperView)]) {
        [self.delegate datePickerViewRefreshSuperView];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
}

@end
