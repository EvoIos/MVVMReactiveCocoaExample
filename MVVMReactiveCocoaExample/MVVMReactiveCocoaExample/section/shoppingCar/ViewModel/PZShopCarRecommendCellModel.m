//
//  PZShopCarRecommendCellModel.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/21.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarRecommendCellModel.h"

@interface PZShopCarRecommendCellModel()
@property (nonatomic,strong) PZShopCarRecommendProduct *product;
@end

@implementation PZShopCarRecommendCellModel
- (instancetype)initWithProduct:(PZShopCarRecommendProduct *)product {
    self = [super init];
    if (self) {
        self.product = product;
    }
    return self;
}

- (NSURL *)imgUrl {
    
    return [NSURL URLWithString:self.product.img];
}

- (NSString *)title {
    return self.product.title;
}

- (CGFloat)price {
    return self.product.price;
}

- (NSInteger)productId {
    return self.product.productId;
}

@end
