//
//  PZProductListViewModel.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/10.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZProductListViewModel.h"
#import "PZNetApiManager.h"

@interface PZProductListViewModel()
@property (nonatomic, strong, readwrite) NSArray *productLists;
@property (nonatomic, strong, readwrite) NSDictionary *selectedDic;
@property (nonatomic, strong, readwrite) RACCommand *fetchDataCommand;
@property (nonatomic, strong, readwrite) RACCommand *selectCommand;
@property (nonatomic, strong, readwrite) RACCommand *submitCommand;
@end

@implementation PZProductListViewModel

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    self.productLists = @[];
    self.selectedDic = @{};
    @weakify(self);
    self.fetchDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [ApiManager fetchDefaultProductListWithBlock:^(PZDefaultProductListModel * _Nullable model, NSError * _Nullable error) {
                @strongify(self);
                if (error) {
                    [subscriber sendError:error];
                } else {
                    if (model.code == 0) {
                        self.productLists = model.data;
                        [subscriber sendNext:@YES];
                        [subscriber sendCompleted];
                    } else {
                        [subscriber sendError:model.error];
                    }
                }
            }];
            return (RACDisposable *)nil;
        }];
    }];
    self.selectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath * indexPath) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            NSMutableDictionary *tmpDic = [self.selectedDic mutableCopy];
            NSNumber *value = tmpDic[indexPath];
            if (!value.boolValue) {
                tmpDic[indexPath] = @(YES);
            } else {
                tmpDic[indexPath] = @(NO);
            }
            self.selectedDic = [tmpDic copy];
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            return (RACDisposable *)nil;
        }];
    }];
    
    self.submitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
//            if ([self makeupSubmitParams].count == 0) {
//                NSError *error = [[NSError alloc] initWithDomain:@"com.ablackcrow.www"
//                                           code:-1
//                                       userInfo:@{@"msg":@"必须选择商品，才能提交！"}];
//                [subscriber sendError:error];
//                return nil;
//            }
            
            NSDictionary *param = @{ @"shopCar":[self makeupSubmitParams].mj_JSONString };
            [ApiManager addShopCarWithParams:param handleBlock:^(PZBaseResponseModel * _Nullable model, NSError * _Nullable error) {
                if (error) {
                    [subscriber sendError:error];
                } else {
                    if (model.code == 0) {
                        [subscriber sendNext:@YES];
                        [subscriber sendCompleted];
                    } else {
                        [subscriber sendError:model.error];
                    }
                }
            }];
            return nil;
        }];
    }];
    
    return self;
}

- (NSArray *)makeupSubmitParams {
    NSMutableArray *tmpArray = [@[] mutableCopy];
    [self.selectedDic enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.boolValue) {
            PZDefaultProductListProduct * product =  self.productLists[indexPath.section].products[indexPath.row];
            NSDictionary *param = @{@"shopId":@(product.shopId),
                                    @"productId":@(product.productId),
                                    @"propertyId":@(product.propertyId),
                                    @"count":@(1)
                                    };
            [tmpArray addObject:param];
        }
    }];
    DLog(@"params: %@",tmpArray);
    return [tmpArray copy];
}

@end
