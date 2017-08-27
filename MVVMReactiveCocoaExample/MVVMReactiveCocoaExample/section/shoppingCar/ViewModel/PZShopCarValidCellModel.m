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

- (RACCommand *)deleteCommand {
    if (!_deleteCommand) {
        @weakify(self);
        _deleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                [ApiManager shopCarDeleteWithParams:@{@"propertyIds":@[@(self.productId)]} handleBlock:^(PZBaseResponseModel * _Nullable model, NSError * _Nullable error) {
                    if (error) {
                        [subscriber sendError:error];
                    } else {
                        if (model.code == 0) {
                            [subscriber sendNext:input];
                            [subscriber sendCompleted];
                        } else {
                            [subscriber sendError:model.error];
                        }
                    }
                }];
                return nil;
            }];
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

@end
