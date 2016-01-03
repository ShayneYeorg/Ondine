//
//  SYEventTableViewController.m
//  ondine
//
//  Created by 杨淳引 on 15/5/27.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

#import "SYEventTableViewController.h"

@interface SYEventTableViewController()
/**
 *   用来存放数据库里取出来的所有事件
 */
@property (nonatomic, strong) NSArray *events;
@end

@implementation SYEventTableViewController
-(NSArray *)events{
    //由于下面这个if语句的存在，导致从add页面pop回来的时候，不会再执行查询方法，数据就没有更新
    if(_events == nil){
        _events = [SYEventTool events];
    }
    return _events;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self detailsOfViewDidLoad];
}

/**
 *   把viewDidLoad里的加载语句整合在这个方法里
 */
-(void)detailsOfViewDidLoad{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"back_icon" highImage:@"back_icon"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(add) image:@"add_icon" highImage:@"add_icon"];
    UIView *foot = [[UIView alloc]init];
    self.tableView.tableFooterView = foot;
}

/**
 *   接受到add页面发送的通知之后，会执行reload:方法
 */
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reload:) name:@"reload" object:nil];
}

/**
 *   刷新页面
 */
-(void)reload:(NSNotification *)text{
    if([text.userInfo[@"reload"] isEqualToString:@"reload"]){
        //由于在self.events的懒加载中的if语句导致self.events!＝nil的时候不执行，所以这里需要再查询一次
        self.events = [SYEventTool events];
        [self.tableView reloadData];
        //让tableView去到页面最下方，能直观看到刚添加的事件
        [self.tableView setContentOffset:CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    }
}

/**
 *   导航栏上的返回按钮的触发方法
 */
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *   导航栏上的添加按钮的触发方法
 */
-(void)add{
    SYAddEventViewController *aevc = [[SYAddEventViewController alloc]init];
    [self.navigationController pushViewController:aevc animated:YES];
}

#pragma mark - 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.events.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    UITableViewCell *cell = [[UITableViewCell alloc]init];
    static NSString *ID = @"EventsSettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    SYEvent *event = self.events[indexPath.row];
    cell.textLabel.text = event.eventName;
    cell.imageView.image = [UIImage imageNamed:event.eventColor];
    
    return cell;
}

@end
