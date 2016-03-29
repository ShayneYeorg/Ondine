//
//  SYCounterViewController.m
//  ondine
//
//  Created by 杨淳引 on 15/5/23.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

#import "SYCounterViewController.h"
#import "SYNavigationController.h"
#import "UIBarButtonItem+Extension.h"
#import "SYSettingViewController.h"
#import "UIView+Extension.h"
#import "SYBtmView.h"
#import "SYEventTool.h"
#import "SYTimeTool.h"
#import "SYDateTool.h"
#import "SYCountingTime.h"
#import "SYCountingTimeTool.h"

#define kLabelWidth [UIScreen mainScreen].bounds.size.width
#define kLabelHeight 30
#define kInfoLabelY self.view.frame.size.height * 0.2
#define kCountLabelY CGRectGetMaxY(self.infoLabel.frame)
#define kStartBtnWidth 100
#define kStartBtnHeight 100

@interface SYCounterViewController ()
/**
 *   点击按钮会在下方弹出的那个页面的蒙板的控制器
 */
@property (nonatomic, strong) UIViewController *bottomShowVc;

/**
 *   用来间隔更新countLabel的内容，造成countLabel有时间走动的效果
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 *   显示事件执行时间上方的说明文字
 */
@property (nonatomic, strong) UILabel *infoLabel;

/**
 *   显示事件执行时间
 */
@property (nonatomic, strong) UILabel *countLabel;
@end

@implementation SYCounterViewController
-(UILabel *)infoLabel{
    if (_infoLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, kInfoLabelY, kLabelWidth, kLabelHeight)];
        _infoLabel = label;
    }
    return _infoLabel;
}

-(UILabel *)countLabel{
    if (_countLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, kCountLabelY, kLabelWidth, kLabelHeight)];
        _countLabel = label;
    }
    return _countLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self detailsOfViewDidLoad];
}

/**
 *   把viewDidLoad里的加载语句整合在这个方法里
 */
-(void)detailsOfViewDidLoad{
    //如果有未移除的时钟，先把它处理掉
    if([self.timer respondsToSelector:@selector(invalidate)]){
        [self.timer invalidate];
    }
    
    //页面背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置导航栏右侧的设置按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(setting) image:@"setting_icon" highImage:@"setting_icon"];
    
    //根据数据库中t_currentEvent表存储的当前事件来判断应该显示哪个按钮
    if ([SYTimeTool getCurrentTimeId] == 0) {
        //如果有另一个按钮，把另一个按钮去掉
        for (UIButton *b in self.view.subviews) {
            [b removeFromSuperview];
        }
        //如果这种状态下还有文字，要去掉文字
        for (UILabel *label in self.view.subviews) {
            [label removeFromSuperview];
        }
        //说明没有正在执行的事件，显示start样式的按钮
        UIButton *startBtn = [[UIButton alloc]init];
        startBtn.width = kStartBtnWidth;
        startBtn.height = kStartBtnHeight;
        startBtn.center = self.view.center;
        [startBtn addTarget:self action:@selector(bottomShowView:) forControlEvents:UIControlEventTouchUpInside];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"startButton"] forState:UIControlStateNormal];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"startButton_selected"] forState:UIControlStateHighlighted];
        [self.view addSubview:startBtn];
    }else{
        //如果有另一个按钮，把另一个按钮去掉
        for (UIButton *b in self.view.subviews) {
            [b removeFromSuperview];
        }
        //说明有正在执行的任务，要显示stop按钮
        UIButton *stopBtn = [[UIButton alloc]init];
        stopBtn.width = kStartBtnWidth;
        stopBtn.height = kStartBtnHeight;
        stopBtn.center = self.view.center;
        [stopBtn setBackgroundImage:[UIImage imageNamed:@"stopButton"] forState:UIControlStateNormal];
        [stopBtn setBackgroundImage:[UIImage imageNamed:@"stopButton_selected"] forState:UIControlStateHighlighted];
        [stopBtn addTarget:self action:@selector(stopCounting:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:stopBtn];
        //调用文字显示方法
        [self showLabel];
    }
}

/**
 *   从数据库里取出当前事件，查询出当前事件的已执行时间，显示出来
 */
-(void)showLabel{
    //文字label
    NSString *currentEvent = [SYTimeTool getCurrentEventName];
    NSString *infoLableText = [NSString stringWithFormat:@"%@已进行了", currentEvent];
    self.infoLabel.text = infoLableText;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.textColor = RGB(0, 150, 30);
    [self.view addSubview:self.infoLabel];
    
    //时间label
    //1、拿到时间开始时间到现在时间的duration
    NSDate *now = [NSDate date];
    NSInteger currentTimeId = [SYTimeTool getCurrentTimeId];
    NSInteger startTime = [SYTimeTool getStartTimeStampByTimeId:currentTimeId];
    NSInteger nowTime = [[SYDateTool transDateToTimeStamp:now]integerValue];
    NSInteger duration = nowTime - startTime;
    //2、把duration转化成时间格式
    SYCountingTime *countingTime = [SYCountingTimeTool transSecondsToCountingTime:duration];
    //3、指定countLabel的内容
    self.countLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)countingTime.hur, (long)countingTime.min, (long)countingTime.sec];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.countLabel];
    //4、让countLabel的内容每秒加1
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:)userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *   时钟更新方式，每秒把countLabel的内容加1
 */
-(void)updateTimer:(NSTimer *)timer{
    SYCountingTime *tempTime = [SYCountingTimeTool transStringToCountingTime:self.countLabel.text];
    tempTime = [SYCountingTimeTool countingTimePlus:tempTime];
    self.countLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)tempTime.hur, (long)tempTime.min, (long)tempTime.sec];
}

/**
 *   由下方弹出页面和AppDelegate发出的通知，这里收到通知，就重新调用viewDidLoad方法刷新页面
 */
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewDidLoad) name:@"reloadCounterView" object:nil];
}

/**
 *   导航栏右侧设置按钮的触发方法
 */
- (void)setting{
    SYSettingViewController *settingView = [[SYSettingViewController alloc] init];
    settingView.title = @"设置";
    [self.navigationController pushViewController:settingView animated:YES];
}

/**
 *   当按钮为start状态下的点击触发方法
 */
- (void)bottomShowView:(UIButton *)btn{
    //从底部弹出新页面SYBtmView
    SYBtmView *btmView = [[SYBtmView alloc]init];
    btmView.width = self.view.width;
    btmView.height = self.view.height;
    [self.tabBarController.view addSubview:btmView];
}

/**
 *   当按钮为stop状态下的点击触发方法
 */
-(void)stopCounting:(UIButton *)btn{
    //将结束数据插入数据库并将当前事件更新为0(无事件)
    NSDate *now = [NSDate date];
    NSInteger currentTimeId = [SYTimeTool getCurrentTimeId];
    [SYTimeTool updateEndTime:now withTimeId:currentTimeId];
    [SYTimeTool updateCurrentTimeId:0];
    
    //计算历时时长并插入数据库
    NSInteger startTime = [SYTimeTool getStartTimeStampByTimeId:currentTimeId];
    NSInteger endTime = [SYTimeTool getEndTimeStampByTimeId:currentTimeId];
    NSInteger duration = endTime - startTime;
    [SYTimeTool insertDuration:duration withTimeId:currentTimeId];
    
    //停止当前的时钟计时，不然在页面里新开一个任务的话，会有两个时钟工作
    [self.timer invalidate];
    
    //重新刷新界面
    [self viewDidLoad];
}



@end
