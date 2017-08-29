//
//  PZShopFormatPresentController.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/29.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopFormatPresentController.h"


@implementation PZShopFormatPresentAnimation
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    
    
    CGRect finalFrame = toViewController.view.frame;
    
    CGRect beginFrame = finalFrame;
    beginFrame.origin.y = finalFrame.origin.y + finalFrame.size.height;
    
    toViewController.view.frame = beginFrame;
    toViewController.view.layer.opacity = 0.0f;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         toViewController.view.frame = finalFrame;
                         toViewController.view.layer.opacity = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

@end

@implementation PZShopFormatDismissedAnimation
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect finalFrame =  [transitionContext finalFrameForViewController:fromViewController];
    CGRect beginFrame = finalFrame;
    beginFrame.origin.y = finalFrame.origin.y + finalFrame.size.height;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         fromViewController.view.frame = beginFrame;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
    
}
@end


@interface PZShopFormatPresentController()
@property (nonatomic, strong) UIView *dimmingView;
@end

@implementation PZShopFormatPresentController
- (UIView *)dimmingView {
    static UIView *instance = nil;
    if (instance == nil) {
        instance = [[UIView alloc] initWithFrame:self.containerView.bounds];
        instance.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return instance;
}

- (void)presentationTransitionWillBegin {
    
    self.dimmingView.frame = self.containerView.bounds;
    self.dimmingView.alpha = 0;
    [self.containerView addSubview:self.dimmingView];
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 1;
    } completion:nil];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    [super presentationTransitionDidEnd:completed];
    if (!completed) {
        [self.dimmingView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin {
    [super dismissalTransitionWillBegin];
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.0f;
        self.presentingViewController.view.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    [super dismissalTransitionDidEnd:completed];
    if (completed) {
        [self.dimmingView removeFromSuperview];
    }
}

- (CGRect)frameOfPresentedViewInContainerView {
    return CGRectMake(0,
                      [UIScreen mainScreen].bounds.size.height * 0.4,
                      [UIScreen mainScreen].bounds.size.width,
                      [UIScreen mainScreen].bounds.size.height * 0.6);
}

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    self.presentedView.frame = [self frameOfPresentedViewInContainerView];
    self.dimmingView.frame = self.containerView.bounds;
}

@end
