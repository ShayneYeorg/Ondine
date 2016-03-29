//
//  SYBtmSubView.m
//  ondine
//
//  Created by 杨淳引 on 15/5/25.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

#import "SYBtmSubView.h"

#define kSubTableX 0
#define kSubTableY 2
#define kSubTableWidth [[UIScreen mainScreen]bounds].size.width
#define kSubTableHeight (self.height - quitBtn.height - 20)
#define kScreenHeight [[UIScreen mainScreen]bounds].size.height
#define kScreenWidth [[UIScreen mainScreen]bounds].size.width


@interface SYBtmSubView() <UITableViewDelegate, UITableViewDataSource>
/**
 *   弹出框里显示所有可选事件的tableView
 */
@property (nonatomic, strong) UITableView *subTable;

/**
 *   用来存放数据库里存放的所有事件的数组
 */
@property (nonatomic, strong) NSArray *events;
@end

@implementation SYBtmSubView
-(NSArray *)events{
    if(_events == nil){
        _events = [SYEventTool events];
    }
    return _events;
}

-(UITableView *)subTable{
    if (_subTable == nil) {
        _subTable = [[UITableView alloc]init];
        _subTable.width = kSubTableWidth;
        _subTable.y = kSubTableX;
        _subTable.dataSource = self;
        _subTable.delegate = self;
        [self addSubview:_subTable];
    }
    return _subTable;
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
    //定义下放弹出框的初始位置和背景颜色
    self.width = kScreenWidth;
    self.height = kScreenHeight * 0.7;
    self.y = kScreenHeight * 0.99;
    self.backgroundColor = [UIColor whiteColor];
    
    //定义页面上的取消按钮
    UIButton *quitBtn = [[UIButton alloc]init];
    [quitBtn addTarget:self action:@selector(quitView) forControlEvents:UIControlEventTouchUpInside];
    [quitBtn setBackgroundImage:[UIImage imageNamed:@"quitButton"] forState:UIControlStateNormal];
    [quitBtn setBackgroundImage:[UIImage imageNamed:@"quitButton_selected"] forState:UIControlStateHighlighted];
    quitBtn.width = 250;  //这个尺寸好看点
    quitBtn.height = 50;
    quitBtn.centerX = self.centerX;
    quitBtn.y = self.height - quitBtn.height - 10;
    [self addSubview:quitBtn];
    
    //此时再来补充subTable的高度和颜色
    self.subTable.height = kSubTableHeight; //这个常量里包含了刚定义好到内容
    self.subTable.backgroundColor = [UIColor whiteColor];
    
    //subTable弹出的动画效果
    [UIView animateWithDuration:0.5 animations:^{
        self.y = [[UIScreen mainScreen]bounds].size.height * 0.3;
    } completion:^(BOOL finished) {
    }];
}

/**
 *   取消按钮的触发方法
 */
- (void)quitView{
    [UIView animateWithDuration:0.5 animations:^{
        self.y = [[UIScreen mainScreen]bounds].size.height;
    } completion:^(BOOL finished) {
        //调用父视图去执行代理方法
        if ([self.delegate respondsToSelector:@selector(btmSubViewDidClickQuitBtn:)]) {
            [self.delegate btmSubViewDidClickQuitBtn:self];
        }
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
}

#pragma mark - 数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.events.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //定义cell的通用属性
    static NSString *ID = @"EventsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc]init];
        cell.selectedBackgroundView.backgroundColor = RGB(240, 239, 245);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    //定义cell的个性属性
    SYEvent *event = self.events[indexPath.row];
    cell.textLabel.text = event.eventName;
    cell.imageView.image = [UIImage imageNamed:event.eventColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //将开始数据插入数据库
    NSString *name = cell.textLabel.text;
    NSInteger eventId = [SYEventTool getEventIdByEventName:name];
    NSDate *now = [NSDate date];
    NSInteger topId = [SYTimeTool insertStartTime:now withEvent:eventId];
    [SYTimeTool updateCurrentTimeId:topId];
    
    //发通知给SYCounterViewController页面，它收到后会去刷新页面
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"reloadCounterView", @"reloadCounterView", nil];
    NSNotification *notification = [NSNotification notificationWithName:@"reloadCounterView" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    [self quitView];
}
@end
