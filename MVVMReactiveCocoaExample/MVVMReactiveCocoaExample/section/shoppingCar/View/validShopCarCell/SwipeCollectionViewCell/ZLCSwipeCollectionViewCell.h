//
//  ZLCSwipeCollectionViewCell.h
//
//  Created by Pace.Z on 2017/7/17.
//  Copyright © 2017年. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const SwipeCollectionViewCurrentSwipeCell;

@interface ZLCSwipeCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIView *revealView;
/// default: YES, if you want to disable panGestureRecoginzer, you can use this property.
@property (nonatomic,assign) BOOL canSwiped;
/// optional: when only use default revealView, you maybe set this property, eg: xxx.deleteButtonTitle = @"delete"
@property (nonatomic,copy) NSString *deleteButtonTitle;
/// optional: when only use default revealView, you can use this function
@property (nonatomic,copy) void(^zlc_delete)(void);

- (void)hideRevealViewAnimated:(BOOL)isAnimated;
@end
