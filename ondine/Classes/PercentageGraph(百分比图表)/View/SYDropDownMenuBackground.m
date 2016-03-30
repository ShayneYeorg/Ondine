//
//  SYDropDownMenuBackground.m
//  ondine
//
//  Created by 杨淳引 on 15/6/3.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

/**  这个类里面的3个属性的关系是这样的：
 *   containerView是一个UIImageView，最外层，用来显示那张绿色的图片作为背景；
 *   content是一个UIView，是containerView的子视图，用来显示文字，它的背景也是绿色；
 *   contentController是content的controller，有了它做接口，就可以在SYDropDownMenuController类里设置content的内容
 */

#import "SYDropDownMenuBackground.h"

@interface SYDropDownMenuBackground()
/**
 *  将来用来显示具体内容的容器
 */
@property (nonatomic, weak) UIImageView *containerView;
@end

@implementation SYDropDownMenuBackground
/**
 *  初始化方法
 */
+ (instancetype)menu
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 先清除掉蒙板的颜色
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//设置下拉框里的内容的controller
- (void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    self.content = contentController.view;
}

//指定下拉框里的内容
- (void)setContent:(UIView *)content
{
    _content = content;
    
    // 调整内容的位置
    content.x = 10; //距离下拉框左边10px
    content.y = 15; //距离下拉框上边10px
    
    //反过来去设置绿色下拉框的高度
    self.containerView.height = CGRectGetMaxY(content.frame) + 11;
    // 设置绿色的宽度
    self.containerView.width = CGRectGetMaxX(content.frame) + 10;
    
    // 添加内容到绿色下拉框中
    [self.containerView addSubview:content];
}

- (UIImageView *)containerView
{
    if (!_containerView) {
        //往蒙板（self）上 添加一个绿色下拉框图片控件
        UIImageView *containerView = [[UIImageView alloc] init];
        containerView.image = [UIImage imageNamed:@"DropDownMenu"];
        containerView.userInteractionEnabled = YES;
        [self addSubview:containerView];
        self.containerView = containerView;
    }
    return _containerView;
}

/**
 *  显示下拉框，并且显示位置会以传进来的UIView为参照
 *
 *  @param from 下拉框会以这个参数为参照来显示
 */
- (void)showFrom:(UIView *)from
{
    //1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    //2.添加自己到窗口上
    [window addSubview:self];
    
    //3.设置尺寸
    self.frame = window.bounds;
    
    //4.计算出from在window的坐标系的坐标，由于绿色图片是添加在等同于window坐标的蒙板（self）坐标上，所以此时绿色图片就可以根据from在window的坐标系的坐标来确定位置了
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    self.containerView.centerX = CGRectGetMidX(newFrame);
    self.containerView.y = CGRectGetMaxY(newFrame);
}

/**
 *  销毁下拉框
 */
- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}
@end
