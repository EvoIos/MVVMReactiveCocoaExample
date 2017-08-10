//
//  PZBaseNavigationController.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/10.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZBaseNavigationController.h"

@interface PZBaseNavigationController ()

@end

@implementation PZBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\U0000e60d"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(back)];
    [leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                NSFontAttributeName:[UIFont fontWithName:@"iconfont"
                                                                                    size:20]}
                                     forState:UIControlStateNormal];

    viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [super pushViewController:viewController animated:animated];
}


@end
