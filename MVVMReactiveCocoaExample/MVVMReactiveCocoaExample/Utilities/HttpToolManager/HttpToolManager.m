//
//  HttpToolManager.m
//

#import "HttpToolManager.h"

@implementation HttpToolManager

+ (HttpToolManager *)shareInstance{
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
        self.operationQueue = manager.operationQueue;
    }
    return self;
}

+ (void)post:(NSString *)url parameters:(NSDictionary *)dict handle:(HttpToolsBlock)block {
    [[HttpToolManager shareInstance].manager POST:url parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,error);
    }];
}

+ (void)get:(NSString *)url parameters:(NSDictionary *)dict handle:(HttpToolsBlock)block{
    [[HttpToolManager shareInstance].manager GET:url parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
