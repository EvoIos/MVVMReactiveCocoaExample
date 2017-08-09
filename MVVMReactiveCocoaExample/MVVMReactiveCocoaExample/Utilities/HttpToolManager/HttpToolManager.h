//
//  HttpToolManager.h
//
#import <Foundation/Foundation.h>

typedef void (^HttpToolsBlock) (id result, NSError* error);

@interface HttpToolManager : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSOperationQueue* operationQueue;

+(HttpToolManager*)shareInstance;

+(void)post:(NSString *)url parameters:(NSDictionary *)dict success:(HttpToolsBlock)block;

+(void)getURL:(NSString *)url andParameters:(NSDictionary *)dict success:(HttpToolsBlock)block;

+ (void)cancelAllOperations;

@end
