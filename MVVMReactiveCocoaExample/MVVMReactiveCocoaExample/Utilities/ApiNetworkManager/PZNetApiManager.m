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

+ (PZNetApiManager *)sharedManager {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (instancetype)init {
    if (self = [super init]) {
        NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        DLog(@"udid: %@",udid);
        [ApiClient.manager.requestSerializer setValue:udid forHTTPHeaderField:@"udid"];
    }
    return self;
}


- (nullable NSString * )urlWithPath:(NSString *)aPath {
    if (!aPath || aPath.length <= 0) {
        return nil;
    }
    NSString *tmp = [aPath stringByAppendingString:aPath];
    DLog(@"tmp: %@",tmp);
    return [NSString stringWithFormat:@"%@%@",BaseUrl,aPath];
}

- (void)fetchDefaultProductListWithBlock:(void (^)( PZDefaultProductListModel * __nullable  model,  NSError * __nullable error))block {
    DLog(@"fetchDefault product list");
    [ApiClient requestJsonDataWithPath:[self urlWithPath:@"/defaultProduct"]
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

- (void)addShopCarWithParams:(NSDictionary *)param handleBlock:(void (^)( PZBaseResponseModel * __nullable  model,  NSError * __nullable error))block {
    [ApiClient requestJsonDataWithPath:[ApiManager urlWithPath:@"/shopCar/add"]
                            withParams:param.mj_JSONObject
                        withMethodType:Post
                              andBlock:^(id data, NSError *error) {
                                  if (!error) {
                                      PZBaseResponseModel *model = [PZBaseResponseModel mj_objectWithKeyValues:data];
                                      block(model,nil);
                                  } else {
                                      block(nil,error);
                                  }
                              }];
}

- (void)shopCarListWithBlock:(void (^)( PZShopCarModel * __nullable  model,  NSError * __nullable error))block {
    [ApiClient requestJsonDataWithPath:[ApiManager urlWithPath:@"/shopCar/list"]
                            withParams:nil
                        withMethodType:Get
                              andBlock:^(id data, NSError *error) {
                                  if (!error) {
                                      PZShopCarModel *model = [PZShopCarModel mj_objectWithKeyValues:data];
                                      block(model,nil);
                                  } else {
                                      block(nil,error);
                                  }
                              }];
}



@end
//NS_ASSUME_NONNULL_END
