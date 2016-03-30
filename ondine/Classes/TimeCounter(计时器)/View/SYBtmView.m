//
//  SYBtmView.m
//  ondine
//
//  Created by 杨淳引 on 15/5/25.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

#import "SYBtmView.h"
#import "SYBtmSubView.h"

@interface SYBtmView() <SYBtmSubViewDelegate>
/**
 *  下方的弹出框
 */
@property (nonatomic, strong) SYBtmSubView *bsView;
@end

@implementation SYBtmView
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
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.05];
    SYBtmSubView *bsv = [[SYBtmSubView alloc]init];
    _bsView = bsv;
    bsv.delegate = self;
    [self addSubview:bsv];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.bsView quitView];
}

#pragma mark SYBtmSubViewDelegate的代理方法
-(void)btmSubViewDidClickQuitBtn:(UIView *)view{
    [self removeFromSuperview];
}

@end
