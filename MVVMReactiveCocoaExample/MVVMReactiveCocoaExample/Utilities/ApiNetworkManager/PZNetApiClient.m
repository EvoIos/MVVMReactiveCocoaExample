//
//  PZNetApiClient.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/18.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZNetApiClient.h"

#define kNetworkMethodName @[@"Get", @"Post", @"Put", @"Delete"]

@implementation PZNetApiClient
+ (PZNetApiClient *)sharedJsonClient {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", nil];
        manager.requestSerializer.timeoutInterval = 15.0f;
        self.manager = manager;
    }
    return self;
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(PZNetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block {
    if (!aPath || aPath.length <= 0) {
        return;
    }
    DLog(@"\n===========request===========\n%@\n%@:\n%@", kNetworkMethodName[method], aPath, params);
    switch (method) {
        case Get: {
            //所有 Get 请求，增加缓存机制
            NSMutableString *localPath = [aPath mutableCopy];
            if (params) {
                [localPath appendString:params.description];
            }
            [self.manager GET:aPath parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 block(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                block(nil, error);
            }];
            
            break;}
        case Post: {
            [self.manager POST:aPath parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                block(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                block(nil, error);
            }];
            break;
        }
        case Put: {
            [self.manager PUT:aPath parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                block(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                block(nil, error);
            }];
            break;
        }
        case Delete:{
            [self.manager DELETE:aPath parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                block(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                block(nil, error);
            }];
            break;
        }
        default:
            break;
    }
}

@end
