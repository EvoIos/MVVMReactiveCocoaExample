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

- (RACCommand *)deleteCommand {
    if (!_deleteCommand) {
        _deleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [self deleteProduct];
        }];
    }
    return _deleteCommand;
}

- (RACCommand *)markCommand {
    if (!_markCommand) {
        _markCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal empty];
        }];
    }
    return _markCommand;
}

/// 删除商品
- (RACSignal *)deleteProduct {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [ApiManager delShopCartWithParams:@{ @"shop_ids":@(self.shopId) } resultBlock:^(ShoppingCarBaseModel *result, NSError *error) {
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
