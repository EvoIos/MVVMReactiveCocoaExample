//
//  PZShopCarValidCellModel.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarValidCellModel.h"

@interface PZShopCarValidCellModel()
@property (nonatomic, strong) PZShopCarProduct *product;
@property (nonatomic,strong,readwrite) RACCommand *markCommand;
@property (nonatomic,strong,readwrite) RACCommand *deleteCommand;
@end

@implementation PZShopCarValidCellModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.state = [[PZShopCarCellStateModel alloc] initWithMarked:NO
                                                           editState:PZShopCarEditStateTypeNormal];
    }
    return self;
}

- (instancetype)initWithProduct:(PZShopCarProduct *)product {
    self = [self init];
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

- (CGFloat)price {
    return self.product.price;
}

- (NSInteger)max {
    return self.product.inventory;
}

- (NSInteger)count {
    return self.product.count;
}

- (NSInteger)propertyId {
    return self.product.propertyId;
}

@end
