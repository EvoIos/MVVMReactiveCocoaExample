//
//  PZShopCarCellStateModel.h
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZShopCarStateEnum.h"

@interface PZShopCarCellStateModel : NSObject
/// 编辑状态
@property (nonatomic,assign) PZShopCarEditStateType editedState;
/// 标记状态
@property (nonatomic,assign,getter=isMarked) BOOL marked;

- (instancetype)initWithMarked:(BOOL)marked editState:(PZShopCarEditStateType )state;
@end
