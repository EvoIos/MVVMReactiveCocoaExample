//
//  PZNetApiManager.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/18.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZNetApiManager.h"
#import "PZNetApiClient.h"


#define ApiClient [PZNetApiClient sharedJsonClient]


@implementation PZNetApiManager

+ (nullable NSURL * )baseURLWithPath:(NSString *)aPath {
    if (!aPath || aPath.length <= 0) {
        return nil;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BaseUrl,aPath];
    return [NSURL URLWithString:urlStr];
}

+ (void)fetchDefaultProductListWithBlock:(void (^)( PZDefaultProductListModel * __nullable  model,  NSError * __nullable error))block {
    [ApiClient requestJsonDataWithPath:@"/defaultProduct"
                            withParams:nil
                        withMethodType:Get
    andBlock:^(id data, NSError *error) {
        if (!error) {
            PZDefaultProductListModel *model = [PZDefaultProductListModel mj_objectWithKeyValues:data];
            block(model,nil);
         } else {
            block(nil,error);
         }
    }];
}

@end
//NS_ASSUME_NONNULL_END
