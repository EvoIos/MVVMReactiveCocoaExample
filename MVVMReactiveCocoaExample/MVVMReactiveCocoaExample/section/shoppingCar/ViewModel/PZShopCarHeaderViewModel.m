//
//  PZShopCarHeaderViewModel.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarHeaderViewModel.h"
#import "PZShopCarHeader.h"

@interface PZShopCarHeaderViewModel()
@property (nonatomic, strong, readwrite) RACCommand *markCommand;
@property (nonatomic, strong, readwrite) RACCommand *editCommand;
@end

@implementation PZShopCarHeaderViewModel

- (instancetype)initWithShopCarData:(PZShopCarData *)data {
    if  (self = [super init]) {
        self.title = [NSString stringWithFormat:@"%@",data.shopName];
        self.logoUrl = [NSURL URLWithString:data.logo];
        self.shopId = data.shopId;
        self.state = [[PZShopCarCellStateModel alloc] initWithMarked:NO
                                                           editState:PZShopCarEditStateTypeNormal];
    }
    return self;
}

- (instancetype)initWithShopCarRecommendData:(PZShopCarRecommendData *)data {
    if (self = [super init]) {
        self.title = [NSString stringWithFormat:@"根据关注的“%@”为你推荐",data.shopName];
        self.logoUrl = [NSURL URLWithString:data.logo];
        self.shopId = data.shopId;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
        self.localImgName = PZShopCarLikeImageName;
    }
    return self;
}

- (RACCommand *)markCommand {
    if (!_markCommand) {
        _markCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal empty];
        }];
    }
    return _markCommand;
}

- (RACCommand *)editCommand {
    if (!_editCommand) {
        _editCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal empty];
        }];
    }
    return _editCommand;
}

@end
