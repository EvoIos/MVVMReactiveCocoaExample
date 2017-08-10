//
//  NetworkAgent.h
//  MVVMReactiveCocoaExample
//
//  from: https://github.com/yuantiku/YTKNetwork
//

#import <Foundation/Foundation.h>

@interface NetworkAgent : NSObject

- (instancetype)init;
+ (instancetype)new;

+ (NetworkAgent *)sharedAgent;

@end
