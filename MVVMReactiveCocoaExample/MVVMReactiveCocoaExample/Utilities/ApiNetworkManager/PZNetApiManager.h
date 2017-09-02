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
#import "PZExistModel.h"
#import "PZShopCarRecommendModel.h"
#import "PZShopFormatModel.h"

#define ApiManager [PZNetApiManager sharedManager]


NS_ASSUME_NONNULL_BEGIN
@interface PZNetApiManager : NSObject

+ (PZNetApiManager *)sharedManager;

- (void)fetchDefaultProductListWithBlock:(void (^)( PZDefaultProductListModel * __nullable  model,  NSError * __nullable error))block;

- (void)addShopCarWithParams:(NSDictionary *)param handleBlock:(void (^)( PZBaseResponseModel * __nullable  model,  NSError * __nullable error))block;

- (void)shopCarListWithBlock:(void (^)( PZShopCarModel * __nullable  model,  NSError * __nullable error))block;

- (void)shopCarRecommendListWithParams:(NSDictionary *)param handleBlock:(void (^)( PZShopCarRecommendModel * __nullable  model,  NSError * __nullable error))block;

- (void)shopCarDeleteWithParams:(NSDictionary *)param handleBlock:(void (^)( PZBaseResponseModel * __nullable  model,  NSError * __nullable error))block;

- (void)shopCarChangeCountWithParams:(NSDictionary *)param handleBlock:(void (^)( PZBaseResponseModel * __nullable  model,  NSError * __nullable error))block;

- (void)shopCarPropertyListWithParams:(NSDictionary *)param handleBlock:(void (^)( PZShopFormatModel * __nullable  model,  NSError * __nullable error))block;

- (void)shopCarChangePropertyWithParams:(NSDictionary *)param handleBlock:(void (^)( PZBaseResponseModel * __nullable  model,  NSError * __nullable error))block;

- (void)shopCarSaveWithParams:(NSDictionary *)param handleBlock:(void (^)( PZBaseResponseModel * __nullable  model,  NSError * __nullable error))block;

- (void)shopCarSubmitWithParams:(NSDictionary *)param handleBlock:(void (^)( PZBaseResponseModel * __nullable  model,  NSError * __nullable error))block;
@end
NS_ASSUME_NONNULL_END
