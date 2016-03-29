//
//  SYNavigationController.m
//  ondine
//
//  Created by 杨淳引 on 15/5/23.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

#import "SYNavigationController.h"
#import "UIBarButtonItem+Extension.h"

@implementation SYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self detailsOfViewDidLoad];
}

/**
 *   把viewDidLoad里的加载语句整合在这个方法里
 */
- (void)detailsOfViewDidLoad {
    //指定导航控制器的背景色为程序统一色
    self.navigationBar.barTintColor = RGB(0, 150, 30);
    
    // 设置navigationBar标题的颜色
    NSMutableDictionary *navTitleAttrs = [NSMutableDictionary dictionary];
    navTitleAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:navTitleAttrs];
}

/**
 *  这个是重写的方法，为了能够拦截push进来的控制器进行个性化修改，隐藏tabBar
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //取到第二级或第二级以下的viewController（即不是根控制器的其他控制器）做修改
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    //做完个性化修改，然后仍然执行方法本身的内容
    [super pushViewController:viewController animated:animated];
}

/**
 *   设置状态栏颜色为白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    //亮色
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
