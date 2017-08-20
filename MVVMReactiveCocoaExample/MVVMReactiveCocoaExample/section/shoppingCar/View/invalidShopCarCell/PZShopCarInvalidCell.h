//
//  PZShopCarInvalidCell.h
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "ZLCSwipeCollectionViewCell.h"
#import "PZShopCarInvalidCellModel.h"

@interface PZShopCarInvalidCell : ZLCSwipeCollectionViewCell
@property (nonatomic,strong) PZShopCarInvalidCellModel *viewModel;

@property (nonatomic, copy) void(^deleteOneProduct)(void);
@property (nonatomic, copy) void(^findSimilarProduct)(void);
@end
