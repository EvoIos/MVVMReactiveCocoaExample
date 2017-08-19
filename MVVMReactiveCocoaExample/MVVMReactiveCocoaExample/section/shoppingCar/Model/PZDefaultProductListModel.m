//
//  PZDefaultProductListModel.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/10.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZDefaultProductListModel.h"

@implementation PZDefaultProductListModel
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [PZDefaultProductListData class]};
}
@end

@implementation PZDefaultProductListData
+ (NSDictionary *)objectClassInArray{
    return @{@"products" : [PZDefaultProductListProduct class]};
}
@end

@implementation PZDefaultProductListProduct

@end


