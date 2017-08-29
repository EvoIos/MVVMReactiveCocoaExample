//
//  PZShopCarValidCell.h
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLCSwipeCollectionViewCell.h"
#import "PZShopCarNormalStateView.h"
#import "PZShopCarEditedStateView.h"
#import "PZShopCarValidCellModel.h"

@interface PZShopCarValidCell : ZLCSwipeCollectionViewCell

@property (nonatomic, strong) PZShopCarValidCellModel * viewModel;

@property (nonatomic, strong) RACSubject *deleteSignal;
@property (nonatomic, strong) RACSubject *markSignal;


/// 选择规格
@property (nonatomic,copy) void(^tapDownArrowButton)(void);
/// 修改商品数量
@property (nonatomic,copy) void(^changeShoppingCount)(PZCalculationStyle style,NSInteger currentValue);
/// textField 开始编辑
@property (nonatomic,copy) void(^didBeginEditing)(UITextField *textField,ZLCSwipeCollectionViewCell *cell);
/// 取消编辑状态
- (void)endEditing;
@end
