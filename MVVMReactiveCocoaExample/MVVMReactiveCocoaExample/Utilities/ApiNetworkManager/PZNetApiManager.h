//
//  PZNetApiManager.h
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/18.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZBaseResponseModel.h"
#import "PZDefaultProductListModel.h"
#import "PZShopCarModel.h"

#define ApiManager [PZNetApiManager sharedManager]


NS_ASSUME_NONNULL_BEGIN
@interface PZNetApiManager : NSObject

+ (PZNetApiManager *)sharedManager;

- (void)fetchDefaultProductListWithBlock:(void (^)( PZDefaultProductListModel * __nullable  model,  NSError * __nullable error))block;

- (void)addShopCarWithParams:(NSDictionary *)param handleBlock:(void (^)( PZBaseResponseModel * __nullable  model,  NSError * __nullable error))block;

- (void)shopCarListWithBlock:(void (^)( PZShopCarModel * __nullable  model,  NSError * __nullable error))block;


@end
NS_ASSUME_NONNULL_END
