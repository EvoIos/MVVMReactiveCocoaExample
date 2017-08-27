//
//  PZShopCarValidHeaderView.h
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZShopCarModel.h"
#import "PZShopCarHeaderViewModel.h"
@interface PZShopCarValidHeaderView : UICollectionReusableView
@property (nonatomic,strong) PZShopCarHeaderViewModel *viewModel;

@end
