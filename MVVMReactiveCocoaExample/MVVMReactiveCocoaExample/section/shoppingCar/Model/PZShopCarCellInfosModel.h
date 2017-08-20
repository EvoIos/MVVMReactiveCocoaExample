//
//  PZShopCarCellInfosModel.h
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZShopCarHeaderViewModel.h"

@interface PZShopCarCellInfosModel : NSObject
@property (nonatomic,strong) PZShopCarHeaderViewModel *headerViewModel;
//@property (nonatomic,strong) ShoppingInfoInvalidFooterViewModel *footerViewModel;

/// [cellModel,cellModel...]
@property (nonatomic,strong) NSArray *cellViewModels;

- (instancetype)init;
@end
