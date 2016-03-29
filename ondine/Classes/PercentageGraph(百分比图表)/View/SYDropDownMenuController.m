//
//  SYDropDownMenuController.m
//  ondine
//
//  Created by 杨淳引 on 15/6/3.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

#import "SYDropDownMenuController.h"

@implementation SYDropDownMenuController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(0, 150, 30);
}

/**
 *  让下拉框显示参数按钮的title
 *
 *  @param btn       按钮
 */
-(void)setDetail:(UIButton *)btn{
    //1、取得参数按钮的内容
    NSInteger duration = [btn.currentTitle integerValue];
    SYCountingTime *ctDuration = [SYCountingTimeTool transSecondsToCountingTime:duration];
    
    //2、显示说明文字
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    infoLabel.text = @"总共用时";
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.font = [UIFont systemFontOfSize:13.0];
    [self.view addSubview:infoLabel];
    
    //3、显示总时长
    UILabel *durationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 80, 20)];
    durationLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)ctDuration.hur, (long)ctDuration.min, (long)ctDuration.sec];
    durationLabel.textAlignment = NSTextAlignmentCenter;
    durationLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:durationLabel];
}

@end



