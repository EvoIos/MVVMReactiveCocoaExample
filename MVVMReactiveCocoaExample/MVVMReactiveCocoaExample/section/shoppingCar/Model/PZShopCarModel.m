//
//  PZShopCarModel.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/19.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarModel.h"

@implementation PZShopCarModel
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [PZShopCarData class]};
}
@end

@implementation PZShopCarData
+ (NSDictionary *)objectClassInArray{
    return @{@"products" : [PZShopCarProduct class]};
}

@end

@implementation PZShopCarProduct

@end

