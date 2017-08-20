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


- (RACCommand *)deleteCommand {
    if (!_deleteCommand) {
        _deleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [self deleteProduct];
        }];
    }
    return _deleteCommand;
}

/// 删除商品
- (RACSignal *)deleteProduct {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [ShoppingCarApi delShopCartWithParams:@{ @"shop_ids":@(self.shopId) } resultBlock:^(ShoppingCarBaseModel *result, NSError *error) {
//            if (result.success == YES) {
//                [subscriber sendNext:@YES];
//                [subscriber sendCompleted];
//            } else {
//                NSError *error = [[NSError alloc] initWithDomain:@"cc.txooo.com" code:-1 userInfo:@{@"msg":@"deleteOneProductError"}];
//                [subscriber sendError:error];
//            }
//        }];
        return nil;
    }];
}

@end
