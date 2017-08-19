//
//  PZBaseResponseModel.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/18.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZBaseResponseModel.h"

@implementation PZBaseResponseModel

- (NSError *)error {
    return [[NSError alloc] initWithDomain:@"com.ablackcrow.www"
                                      code:self.code
                                  userInfo:@{@"msg":self.msg}];
}

@end
