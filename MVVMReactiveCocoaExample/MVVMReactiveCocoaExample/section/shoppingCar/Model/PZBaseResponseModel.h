//
//  PZBaseResponseModel.h
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/18.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZBaseResponseModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy)   NSString *msg;

- (NSError *)error;

@end
