//
//  SYDatePickerBgView.m
//  ondine
//
//  Created by 杨淳引 on 15/6/1.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

#import "SYDatePickerBgView.h"

@implementation SYDatePickerBgView
-(SYDatePickerView *)dpView{
    if (_dpView == nil) {
        SYDatePickerView *dpv = [[SYDatePickerView alloc]init];
        _dpView = dpv;
    }
    return _dpView;
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
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.dpView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self quitView];
}

//退出页面
- (void)quitView{
    [UIView animateWithDuration:0.5 animations:^{
        self.dpView.y = [[UIScreen mainScreen]bounds].size.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
