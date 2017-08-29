//
//  PZShopCarInvalidCellModel.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarInvalidCellModel.h"

@interface PZShopCarInvalidCellModel()
@property (nonatomic, strong) PZShopCarProduct *product;
@property (nonatomic,strong,readwrite) RACCommand *deleteCommand;

@end

@implementation PZShopCarInvalidCellModel
- (instancetype)initWithModel:(PZShopCarProduct *)product {
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

- (NSString *)subTitle {
    return self.product.propertyTitle;
}

- (NSInteger)shopId {
    return self.product.shopId;
}

- (NSInteger)productId {
    return self.product.productId;
}

- (NSInteger)propertyId {
    return self.product.propertyId;
}

@end
