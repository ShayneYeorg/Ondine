//
//  SYPercentageGraphViewController.m
//  ondine
//
//  Created by 杨淳引 on 15/6/1.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

#import "SYPercentageGraphViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenheight [UIScreen mainScreen].bounds.size.height
#define kBtnHeight 40
#define kStartBtnY (64 + 10)
#define kEndBtnY (kStartBtnY + kBtnHeight + 10)
#define kPcgViewViewY (kEndBtnY + kBtnHeight + 10)
#define kPcgViewHeight (kScreenheight - kPcgViewViewY - 48)

@interface SYPercentageGraphViewController()
/**
 *   点击选择开始日期
 */
@property (nonatomic, strong) UIButton *startBtn;

/**
 *   点击选择结束日期
 */
@property (nonatomic, strong) UIButton *endBtn;

/**
 *   记录开始按钮的日期的时间戳
 */
@property (nonatomic ,assign) NSInteger startDate;

/**
 *   记录结束按钮的日期的时间戳
 */
@property (nonatomic ,assign) NSInteger endDate;

/**
 *   点击按钮弹出来的SYDatePickerBgView
 */
@property (nonatomic, strong) SYDatePickerBgView *dpbgView;

/**
 *   画图表的view
 */
@property (nonatomic, strong) SYPcGraphView *pcgView;

/**
 *   这个属性用来记录用户上一次点击的是哪一个日期选择按钮
 */
@property (nonatomic, strong) NSString *click;
@end

@implementation SYPercentageGraphViewController
-(UIButton *)startBtn{
    if(_startBtn == nil){
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, kStartBtnY, kScreenWidth, kBtnHeight)];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:@"请选择开始日期" forState:UIControlStateNormal];
        [btn setTitleColor:RGB(0, 150, 30) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickPickBtn:) forControlEvents:UIControlEventTouchUpInside];
        _startBtn = btn;
        _startBtn.tag = 1;//用tag不是特别好，以后要优化此处
    }
    return _startBtn;
}

-(UIButton *)endBtn{
    if(_endBtn == nil){
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, kEndBtnY, kScreenWidth, kBtnHeight)];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:@"请选择结束日期" forState:UIControlStateNormal];
        [btn setTitleColor:RGB(0, 150, 30) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickPickBtn:) forControlEvents:UIControlEventTouchUpInside];
        _endBtn = btn;
    }
    return _endBtn;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self detailsOfViewDidLoad];
}

/**
 *   把viewDidLoad里的加载语句整合在这个方法里
 */
-(void)detailsOfViewDidLoad{
    self.view.backgroundColor = RGB(240, 239, 245);
    
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.endBtn];
    
    self.pcgView = [[SYPcGraphView alloc]initWithFrame:CGRectMake(0, kPcgViewViewY, kScreenWidth, kPcgViewHeight)];
    [self.view addSubview:self.pcgView];
    
    [self refreshGraph];
}

/**
 *   刷新柱形图显示界面self.pcgView，在这个方法里会判断查询条件是否合法
 */
-(void)refreshGraph{
    if ([self.startBtn.titleLabel.text isEqualToString:@"请选择开始日期"] || [self.endBtn.titleLabel.text isEqualToString:@"请选择结束日期"]) {
        return;
    }else if((self.startDate == self.endDate) || (self.startDate > self.endDate)){
        [[[UIAlertView alloc]initWithTitle:@"查询失败" message:@"日期输入有误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
    }else{
        [self.pcgView drawGraphWithStartTimeStamp:self.startDate endTimeStamp:self.endDate];
    }
}

/**
 *   日期按钮的点击触发方法
 */
-(void)clickPickBtn:(UIButton *)btn{
    //更新self.click，记录下点击的是哪一个按钮
    if (btn.tag == 1) {
        self.click = @"start";
    }else{
        self.click = @"end";
    }
    
    //从底部弹出新页面SYDatePickerBgView
    self.dpbgView = [[SYDatePickerBgView alloc]init];
    self.dpbgView.dpView.delegate = self;
    self.dpbgView.width = self.view.width;
    self.dpbgView.height = self.view.height;
    [self.tabBarController.view addSubview:self.dpbgView];
}

#pragma mark - SYDatePickerViewDelegate代理方法
-(void)datePickerViewDidClickConfirmBtn:(UIView *)view withDate:(NSDate *)date{
    [self.dpbgView quitView];
    
    //根据self.click所存放的上一次点击的日期选择按钮，来将date picker选出来的日期存放进对应的属性内
    NSString *selectedDate = [SYDateTool transDateToShortString:date];
    if ([self.click isEqualToString:@"start"]) {
        [self.startBtn setTitle:selectedDate forState:UIControlStateNormal];
        self.startDate = [SYDateTool getStartTimeStampInADate:date];
    }else if([self.click isEqualToString:@"end"]){
        [self.endBtn setTitle:selectedDate forState:UIControlStateNormal];
        self.endDate = [SYDateTool getEndTimeStampInADay:date];
    }
}

-(void)datePickerViewRefreshSuperView{
    [self refreshGraph];
}

@end

