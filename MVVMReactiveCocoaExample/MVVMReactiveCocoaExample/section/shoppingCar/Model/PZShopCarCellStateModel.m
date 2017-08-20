//
//  PZShopCarCellStateModel.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarCellStateModel.h"

@implementation PZShopCarCellStateModel
- (instancetype)initWithMarked:(BOOL)marked editState:(PZShopCarEditStateType)state {
    if (self = [super init]) {
        self.marked = marked;
        self.editedState = state;
    }
    return self;
}
@end
