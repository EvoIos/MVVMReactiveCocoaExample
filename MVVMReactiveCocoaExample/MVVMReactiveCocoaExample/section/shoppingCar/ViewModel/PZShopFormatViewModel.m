//
//  PZShopFormatViewModel.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/29.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopFormatViewModel.h"
#import "PZShopCarHeader.h"

@interface PZShopFormatViewModel()
@property (nonatomic, strong) NSArray <NSNumber *> *sizeArray;
@property (nonatomic, strong, readwrite) NSArray *datas;
@property (nonatomic, strong, readwrite) RACCommand *fetchDataCommand;
@end

@implementation PZShopFormatViewModel

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.datas = @[];
    self.sizeArray = @[];
    
    @weakify(self);
    self.fetchDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            [ApiManager shopCarPropertyListWithParams:@{@"productId":input} handleBlock:^(PZShopFormatModel * _Nullable model, NSError * _Nullable error) {
                @strongify(self);
                if (error) {
                    [subscriber sendError:error];
                } else if (model.code == 0){
                    self.datas = model.data;
                    
                    self.sizeArray = [[model.data.rac_sequence
                                       map:^id(PZShopFormatData * value) {
                                           CGSize memoSize = [value.propertyTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
                                           CGFloat width = memoSize.width + 5;
                                           return @(width);
                                       }] array];
                    
                    [subscriber sendNext:@YES];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:model.error];
                }
            }];
            
            return nil;
        }];
    }];
    
    return self;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.sizeArray[indexPath.row].floatValue, 25);
}

@end
