//
//  JYNavigationController.m
//  SeptOnCamera
//
//  Created by Sept on 16/1/18.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYNavigationController.h"

@interface JYNavigationController ()

@end

@implementation JYNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

// 掩藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark ==== 设置横屏 ====
- (BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

@end
