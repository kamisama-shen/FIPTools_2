//
//  UIApplication+Visible.h
//  DLSmartInfo
//
//  Created by ltf on 2018/9/11.
//  Copyright © 2018年 DFITC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Visible)
- (UIWindow *)mainWindow;
- (UIViewController *)visibleViewController;
- (UINavigationController *)visibleNavigationController;
@end
