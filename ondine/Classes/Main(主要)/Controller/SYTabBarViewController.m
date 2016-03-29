//
//  SYTabBarViewController.m
//  ondine
//
//  Created by 杨淳引 on 15/5/22.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

#import "SYTabBarViewController.h"
#import "SYCounterViewController.h"
#import "SYPercentageGraphViewController.h"
#import "SYNavigationController.h"

@implementation SYTabBarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self detailsOfViewDidLoad];
}

/**
 *   把viewDidLoad里的加载语句整合在这个方法里
 */
-(void)detailsOfViewDidLoad{
    //初始化子控制器，这里指定了程序会有几个页面
    SYCounterViewController *counterView = [[SYCounterViewController alloc] init];
    [self addChildVc:counterView navTitle:@"ondine" tabbarTitle:@"计时" image:@"tabbar_counter" selectedImage:@"tabbar_counter_selected"];
    
    //先砍掉这个功能
    //    SYRectGraphViewController *rectGraphView = [[SYRectGraphViewController alloc] init];
    //    [self addChildVc:rectGraphView navTitle:@"ondine" tabbarTitle:@"矩形图" image:@"tabbar_rect_graph" selectedImage:@"tabbar_rect_graph_selected"];
    
    SYPercentageGraphViewController *percentageGraphView = [[SYPercentageGraphViewController alloc] init];
    [self addChildVc:percentageGraphView navTitle:@"ondine" tabbarTitle:@"统计" image:@"tabbar_percentage_graph" selectedImage:@"tabbar_percentage_graph_selected"];
}


/**
 *  这个方法用来添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc navTitle:(NSString *)navTitle tabbarTitle:(NSString *)tabbarTitle image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    //设置子控制器的文字
    childVc.tabBarItem.title = tabbarTitle; // 设置tabbar的文字
    childVc.navigationItem.title = navTitle; // 设置navigationBar的文字
    
    //设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置tabBar文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = RGB(150, 150, 150);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = RGB(0, 150, 30);
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    //给子控制器上面包装一个导航控制器
    SYNavigationController *nav = [[SYNavigationController alloc] initWithRootViewController:childVc];
    
    //添加导航控制器为子控制器
    [self addChildViewController:nav];
}

@end
