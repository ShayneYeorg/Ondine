//
//  SYSettingViewController.m
//  ondine
//
//  Created by 杨淳引 on 15/5/23.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

#import "SYSettingViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeigth [UIScreen mainScreen].bounds.size.height

@interface  SYSettingViewController() <UITableViewDataSource, UITableViewDelegate>
/**
 *   在页面里显示的tableView
 */
@property (nonatomic, strong) UITableView *subTable;
@end

@implementation SYSettingViewController
-(UITableView *)subTable{
    if (_subTable == nil) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth);
        _subTable = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _subTable.dataSource = self;
        _subTable.delegate = self;
        [self.view addSubview:_subTable];
    }
    return _subTable;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setIcon];
}

/**
 *   设置导航栏上的按钮
 */
-(void)setIcon{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"back_icon" highImage:@"back_icon"];
    self.subTable.bounces = NO;
}

/**
 *   导航栏上的返回按钮的触发方法
 */
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"SettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = @"事件";
    cell.imageView.image = [UIImage imageNamed:@"eventButton"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SYEventTableViewController *etvc = [[SYEventTableViewController alloc]init];
    etvc.title = @"事件";
    [self.navigationController pushViewController:etvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
