//
//  PZShopCarSettlementViewModel.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/21.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarSettlementViewModel.h"

@interface PZShopCarSettlementViewModel()
@property (nonatomic, strong, readwrite) RACCommand *markCommand;
@end

@implementation PZShopCarSettlementViewModel

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }
    self.markCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@{@"type":@"all"}];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    return self;
}

@end
