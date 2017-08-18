//
//  PZNetApiManager.h
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/18.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZDefaultProductListModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface PZNetApiManager : NSObject

+ (void)fetchDefaultProductListWithBlock:(void (^)( PZDefaultProductListModel * __nullable  model,  NSError * __nullable error))block;

@end
NS_ASSUME_NONNULL_END
