//
//  ZLCSwipeCollectionViewCell.m
//
//  Created by Pace.Z on 2017/7/17.
//  Copyright © 2017年. All rights reserved.
//

#import "ZLCSwipeCollectionViewCell.h"
#import <objc/runtime.h>

@interface UIView (SuperCollectionView)
- (UICollectionView *)zlc_superCollectionView;
@end

@implementation UIView (SuperCollectionView)
- (UICollectionView *)zlc_superCollectionView {
    UIView *superview = self.superview;
    while (superview != nil) {
        if ([superview isKindOfClass:[UICollectionView class]]) {
            return (id)superview;
        }
        superview = [superview superview];
    }
    return nil;
}
@end


NSString * const SwipeCollectionViewCurrentSwipeCell = @"currentSwipeCell";

@interface ZLCSwipeCollectionViewCell()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *snapShotView;
@property (nonatomic,strong) UIView *snapBackgroundView;
@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;
@end

@implementation ZLCSwipeCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.snapBackgroundView removeFromSuperview];
    self.snapBackgroundView = nil;
    [self.snapShotView removeFromSuperview];
    self.snapShotView = nil;
    [self.revealView removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.canSwiped = YES;
        [self configureGestureRecognizer];
    }
    return self;
}

- (void)configureGestureRecognizer {
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(zlc_panAction:)];
    self.panGesture.delegate = self;
    [self addGestureRecognizer:self.panGesture];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.revealView.frame = (CGRect) {
        .origin = CGPointMake( CGRectGetWidth(self.frame) - CGRectGetWidth(self.revealView.frame), 0.0f),
        .size = self.revealView.frame.size
    };
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *gesture = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [gesture velocityInView:self];
        if (fabs(point.x) > fabs(point.y)) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return otherGestureRecognizer != self.zlc_superCollectionView.panGestureRecognizer;
}

- (void)setCanSwiped:(BOOL)canSwiped {
    _canSwiped = canSwiped;
    self.panGesture.enabled = canSwiped;
}

#pragma mark - event response
- (void)zlc_deleteAction:(UIButton *)sender {
    [self hideRevealViewAnimated:YES];
    if (self.zlc_delete) {
        self.zlc_delete();
    }
}

- (void)zlc_panAction:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            [self _closeOtherOpeningCell];
            [self addSubview:self.snapBackgroundView];
            [self addSubview:self.revealView];
            [self addSubview:self.snapShotView];
            
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint translationPoint  = [panGesture translationInView:self];
            CGPoint centerPoint = CGPointMake(0, self.snapShotView.center.y);
            centerPoint.x = MIN(CGRectGetWidth(self.frame)/2 ,
                                                self.snapShotView.center.x + translationPoint.x);;
            [panGesture setTranslation:CGPointZero inView:self];
            self.snapShotView.center = centerPoint;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            CGPoint velocity = [panGesture velocityInView:self];
            if ([self _bigThenRevealViewHalfWidth] || [self _shouldShowRevealViewForVelocity:velocity]) {
                [self showRevealViewAnimated:YES];
            }
            if ([self _lessThenRevealViewHalfWidth] || [self _shouldHideRevealViewForVelocity:velocity]) {
                if (CGPointEqualToPoint(self.snapShotView.center, self.center)) { return; }
                [self hideRevealViewAnimated:YES];
            }
        }
            break;
        default:
            break;
    }
}

- (BOOL)_shouldHideRevealViewForVelocity:(CGPoint)velocity {
    return fabs(velocity.x) > CGRectGetWidth(self.revealView.frame)/2 && velocity.x > 0;
}

- (BOOL)_shouldShowRevealViewForVelocity:(CGPoint)velocity {
    return fabs(velocity.x) > CGRectGetWidth(self.revealView.frame)/2 && velocity.x < 0;
}

- (BOOL)_bigThenRevealViewHalfWidth {
    return fabs(CGRectGetMinX(self.snapShotView.frame)) >= CGRectGetWidth(self.revealView.frame)/2;
}

- (BOOL)_lessThenRevealViewHalfWidth {
    return fabs(CGRectGetMinX(self.snapShotView.frame)) < CGRectGetWidth(self.revealView.frame)/2;
}

- (void)showRevealViewAnimated:(BOOL)isAnimated {
    [UIView animateWithDuration:isAnimated ? 0.1: 0
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.snapShotView.center = CGPointMake( CGRectGetWidth(self.frame)/2 - CGRectGetWidth(self.revealView.frame),
                                                                self.snapShotView.center.y );
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)hideRevealViewAnimated:(BOOL)isAnimated {
    [UIView animateWithDuration:isAnimated ? 0.1: 0
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.snapShotView.center = CGPointMake( CGRectGetWidth(self.frame)/2,
                                                                self.snapShotView.center.y );
                     }
                     completion:^(BOOL finished) {
                         [self.snapBackgroundView removeFromSuperview];
                         self.snapBackgroundView = nil;
                         [self.snapShotView removeFromSuperview];
                         self.snapShotView = nil;
                         [self.revealView removeFromSuperview];
                     }];
}

- (void)_closeOtherOpeningCell {
    if (self.zlc_superCollectionView) {
        ZLCSwipeCollectionViewCell *currentCell = objc_getAssociatedObject(self.zlc_superCollectionView,(__bridge const void *)(SwipeCollectionViewCurrentSwipeCell));
        if (currentCell != self) {
            [currentCell hideRevealViewAnimated:YES];
        }
        objc_setAssociatedObject(self.zlc_superCollectionView, (__bridge const void *)(SwipeCollectionViewCurrentSwipeCell), self, OBJC_ASSOCIATION_ASSIGN);
    }
}

#pragma mark - lazy
- (UIView *)snapBackgroundView {
    if (!_snapBackgroundView) {
        _snapBackgroundView = ({
            UIView *tmpView = [[UIView alloc] initWithFrame:self.bounds];
            tmpView.backgroundColor = [UIColor whiteColor];
            tmpView;
        });
    }
    return _snapBackgroundView;
}

- (UIView *)snapShotView {
    if (!_snapShotView) {
        _snapShotView = [self snapshotViewAfterScreenUpdates:NO];
    }
    return _snapShotView;
}
- (UIView *)revealView {
    if (!_revealView) {
        _revealView = ({
            UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 55, 0, 55, self.frame.size.height)];
            tmpView.backgroundColor = [UIColor clearColor];
            tmpView;
        });
        UIButton *deleteButton = ({
            UIButton *tmpBtn = [[UIButton alloc] initWithFrame:_revealView.bounds];
            [tmpBtn setTitle:self.deleteButtonTitle == nil? @"删除":self.deleteButtonTitle forState:UIControlStateNormal];
            [tmpBtn addTarget:self action:@selector(zlc_deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [tmpBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:58/255.0 blue:58/255.0 alpha:1]];
            tmpBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            tmpBtn;
        });
        [_revealView addSubview:deleteButton];
    }
    return _revealView;
}

@end
