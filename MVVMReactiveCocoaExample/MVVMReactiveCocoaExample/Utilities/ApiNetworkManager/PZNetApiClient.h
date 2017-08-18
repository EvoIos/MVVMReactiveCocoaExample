//
//  PZNetApiClient.h
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/18.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
typedef NS_ENUM(NSInteger,PZNetworkMethod) {
    Get = 0,
    Post,
    Put,
    Delete
};

@interface PZNetApiClient : NSObject
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSOperationQueue* operationQueue;

+ (PZNetApiClient *)sharedJsonClient;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(PZNetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block;
@end
