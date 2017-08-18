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
            [PZNetApiManager fetchDefaultProductListWithBlock:^(id data, NSError *error) {
                @strongify(self);
                if (error) {
                    [subscriber sendError:error];
                } else {
                    PZDefaultProductListModel *model = [PZDefaultProductListModel mj_objectWithKeyValues:data];
                    if (model.code == 0) {
                        self.productLists = model.data;
                        [subscriber sendNext:model];
                    } else {
                        NSError *tmpError = [[NSError alloc] initWithDomain:@"com.ablackcrow.www" code:model.code userInfo:@{@"msg":model.msg}];
                        [subscriber sendError:tmpError];
                    }
                }

            }];
            
            return (RACDisposable *)nil;
        }];
    }];
    self.selectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath * indexPath) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
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
    
    return self;
}

@end
