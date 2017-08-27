//
//  PZShopCarEditedStateView.h
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZCalculationView.h"

@interface PZShopCarEditedStateView : UIView

@property (nonatomic,strong) RACCommand *deleteCommand;

/// 是否进入编辑状态
@property (nonatomic,assign) BOOL isShowEditButton;
/// 是否被标记
@property (nonatomic,assign) BOOL isMarked;
/// 当前数量
@property (nonatomic,assign) NSUInteger currentCount;
/// default: ∞，最大值数量，即加按钮能达到的最大数值。
@property (nonatomic,assign) NSUInteger max;
/// 规格描述
@property (nonatomic,copy) NSString *subTitle;
/// 删除
@property (nonatomic,copy) void(^deleteAction)(void);
/// 选择规格
@property (nonatomic,copy) void(^tapDownArrowButton)(void);
/// 修改商品数量
@property (nonatomic,copy) void(^changeShoppingCount)(PZCalculationStyle style,NSInteger currentValue);
///
@property (nonatomic,copy) void(^didBeginEditing)(UITextField *textField);
/// 取消编辑状态
- (void)endEditing;
@end
