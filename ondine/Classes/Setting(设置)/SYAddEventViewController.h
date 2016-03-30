//
//  SYAddEventViewController.h
//  ondine
//
//  Created by 杨淳引 on 15/5/27.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//
/**
 *   这个类用来添加事件
 */

#import <UIKit/UIKit.h>
#import "UIBarButtonItem+Extension.h"
#import "SYEvent.h"
#import "SYEventTool.h"

@interface SYAddEventViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIAlertViewDelegate>
@end
