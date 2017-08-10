//
//  PZProductListViewModel.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/10.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZProductListViewModel.h"

#define ProductListApiPath  @"defaultProduct"

@interface PZProductListViewModel()
@property (nonatomic, strong, readwrite) NSArray *productLists;
@property (nonatomic, strong, readwrite) RACCommand *fetchDataCommand;
@end

@implementation PZProductListViewModel

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    self.productLists = @[];
    @weakify(self);
    self.fetchDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseUrl,ProductListApiPath];
            DLog(@"%@",urlString);
            [HttpToolManager get:urlString parameters:nil handle:^(id result, NSError *error) {
                @strongify(self);
                if (error) {
                    [subscriber sendError:error];
                } else {
                    PZDefaultProductListModel *model = [PZDefaultProductListModel mj_objectWithKeyValues:result];
                    if (model.success == YES) {
                        self.productLists = model.data;
                        [subscriber sendNext:result];
                    } else {
                        NSError *tmpError = [[NSError alloc] initWithDomain:@"com.ablackcrow.www" code:-1 userInfo:@{@"msg":model.msg}];
                        [subscriber sendError:tmpError];
                    }
                }
            }];
            return (RACDisposable *)nil;
        }];
    }];
    return self;
}

@end
