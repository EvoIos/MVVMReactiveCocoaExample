//
//  PZShopCarCellInfosModel.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarCellInfosModel.h"

@implementation PZShopCarCellInfosModel
- (instancetype)init {
    if (self = [super init]) {
        self.cellViewModels = @[] ;
    }
    return self;
}

//- (instancetype)initWithHeaderViewModel:(ShoppingHeaderViewModel *)header cellArray:(NSArray *)cellArray {
//    if (self = [super init]) {
//        self.headerViewModel = header;
//        self.cellViewModels = cellArray;
//    }
//    return self;
//}
@end
