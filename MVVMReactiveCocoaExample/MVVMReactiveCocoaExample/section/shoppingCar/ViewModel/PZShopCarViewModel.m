//
//  PZShopCarViewModel.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/19.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarViewModel.h"

@interface PZShopCarViewModel()
@property (nonatomic, strong, readwrite) RACCommand *fetchDataCommand;
@end

@implementation PZShopCarViewModel

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    @weakify(self);
    self.fetchDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            [ApiManager shopCarListWithBlock:^(PZShopCarModel * _Nullable model, NSError * _Nullable error) {
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

@end
