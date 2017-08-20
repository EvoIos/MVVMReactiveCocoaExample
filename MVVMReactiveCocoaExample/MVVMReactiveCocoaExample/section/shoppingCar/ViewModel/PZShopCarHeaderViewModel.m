//
//  PZShopCarHeaderViewModel.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarHeaderViewModel.h"

@implementation PZShopCarHeaderViewModel
- (instancetype)init {
    if (self = [super init]) {
        self.state = [PZShopCarCellStateModel new];
    }
    return self;
}

- (instancetype)initWithShopCarData:(PZShopCarData *)data {
    if  (self = [self init]) {
        self.title = data.shopName;
        self.logoUrl = [NSURL URLWithString:data.logo];
        self.shopId = data.shopId;
    }
    return self;
}

//- (instancetype)initWithShoppingCarRecommendModel:(RACShoppingInfoRecommendClass *)model {
//    if (self = [super init]) {
//        self.title = model.ClassName;
//        self.logoUrl = [NSURL URLWithString:model.ClassImg];
//    }
//    return self;
//}

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
        self.localImgName = @"猜你喜欢";
        self.isLocal = YES;
    }
    return self;
}

@end
