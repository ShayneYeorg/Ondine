//
//  UIBarButtonItem+Extension.h
//  黑马微博2期
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

@interface UIBarButtonItem (Extension)
//用来快速制定一个页面的barButtonItem的内容
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
@end
