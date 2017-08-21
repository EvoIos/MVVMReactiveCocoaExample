//
//  PZShopCarRecommendCell.h
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/21.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZShopCarRecommendCellModel.h"



@interface PZShopCarRecommendCell : UICollectionViewCell
@property (nonatomic, strong) PZShopCarRecommendCellModel *viewModel;

@property (nonatomic, copy) void(^findSimilarProduct)(void);
@end
