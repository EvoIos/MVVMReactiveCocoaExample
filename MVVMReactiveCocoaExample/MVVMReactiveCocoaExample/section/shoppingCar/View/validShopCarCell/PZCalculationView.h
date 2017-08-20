//
//  PZCalculationView.h
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PZCalculationStyle) {
    PZCalculationStyleDecreaseType = 0,  /**< 减少1个商品 */
    PZCalculationStyleIncreaseType = 1,  /**< 增加1个商品 */
    PZCalculationStyleChangedType  = 2   /**< textfield 修改该商品数量 */
};

/// 达到最大值后的通知
extern NSString * const PZCalculationViewReachesTheMaximumValueNotificationName;

@interface PZCalculationView : UIView
/// default: #d5d5d5
@property (nonatomic,strong) UIColor *borderColor;
/// default: 0.8f
@property (nonatomic,assign) CGFloat borderWidth;
/// default: 3.0f
@property (nonatomic,assign) CGFloat cornerRadius;
/// default: ∞，最大值数量，即加按钮能达到的最大数值。
@property (nonatomic,assign) NSUInteger max;
/// 当前数量
@property (nonatomic,assign) NSUInteger currentCount;
/// 修改商品数量
@property (nonatomic,copy) void(^changeShoppingCount)(PZCalculationStyle style,NSInteger currentValue);
///
@property (nonatomic,copy) void(^didBeginEditing)(UITextField *textField);
/// 取消编辑状态
- (void)endEditing;
@end
