//
//  PZBaseNavigationController.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/10.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZBaseNavigationController.h"
#import "UIImage+PZExtension.h"

@interface PZBaseNavigationController ()

@end

@implementation PZBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.enabled = YES;
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 选择黑色背景
    navBar.barStyle = UIBarStyleDefault;
    // title 字体颜色
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                    DefaultTextLabelColor,
                                    NSForegroundColorAttributeName,
                                    [UIFont systemFontOfSize:18],
                                    NSFontAttributeName ,nil]];
    [navBar setBackgroundColor:DefaultBackgroundColor];
    // 左右按钮颜色
    [navBar setTintColor:DefaultTextLabelColor];
    // status coclor
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if  (self.viewControllers.count > 0) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"\U0000e60b"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(back)];
        [backItem setTitleTextAttributes:@{
                                           NSForegroundColorAttributeName:DefaultTextLabelColor,
                                           NSFontAttributeName:[UIFont fontWithName:@"iconfont"
                                                                               size:18]}
                                forState:UIControlStateNormal];
        
        viewController.navigationItem.leftBarButtonItem = backItem;
    }
    [super pushViewController:viewController animated:animated];
}


@end
