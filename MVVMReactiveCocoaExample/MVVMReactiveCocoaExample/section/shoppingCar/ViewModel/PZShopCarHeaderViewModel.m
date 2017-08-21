//
//  PZShopCarHeaderViewModel.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarHeaderViewModel.h"
#import "PZShopCarHeader.h"

@implementation PZShopCarHeaderViewModel
- (instancetype)init {
    if (self = [super init]) {
        self.state = [PZShopCarCellStateModel new];
    }
    return self;
}

- (instancetype)initWithShopCarData:(PZShopCarData *)data {
    if  (self = [self init]) {
        self.title = [NSString stringWithFormat:@"根据关注的“%@”为你推荐",data.shopName];
        self.logoUrl = [NSURL URLWithString:data.logo];
        self.shopId = data.shopId;
    }
    return self;
}

- (instancetype)initWithShopCarRecommendData:(PZShopCarRecommendData *)data {
    if (self = [self init]) {
        self.title = [NSString stringWithFormat:@"根据关注的“%@”为你推荐",data.shopName];
        self.logoUrl = [NSURL URLWithString:data.logo];
        self.shopId = data.shopId;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
        self.localImgName = PZShopCarLikeImageName;
    }
    return self;
}

@end
