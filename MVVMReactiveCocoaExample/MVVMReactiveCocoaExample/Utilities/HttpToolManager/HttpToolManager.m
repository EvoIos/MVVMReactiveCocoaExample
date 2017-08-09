//
//  HttpToolManager.m
//  Zhuan
//
//  Created by 张金山 on 17/6/15.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "HttpToolManager.h"

@implementation HttpToolManager

+(HttpToolManager *)shareInstance{
    static HttpToolManager *request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[HttpToolManager alloc] init];
        
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10.0f;
        request.manager = manager;
        request.operationQueue = request.manager.operationQueue;
    });
    
    return request;
}

+(void)post:(NSString *)url parameters:(NSDictionary *)dict success:(HttpToolsBlock)block {
    NSString *validUrl =  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]];
    [[HttpToolManager shareInstance].manager POST:validUrl parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,error);
    }];
}

+(void)get:(NSString *)url parameters:(NSDictionary *)dict success:(HttpToolsBlock)block{
    NSString *validUrl =  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]];
    [[HttpToolManager shareInstance].manager GET:validUrl parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,error);
    }];
}

+ (void)cancelAllOperations{
    [[HttpToolManager shareInstance].operationQueue cancelAllOperations];
}

@end
