//
//  PZShopCarRecommendModel.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarRecommendModel.h"

@implementation PZShopCarRecommendModel
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [PZShopCarRecommenData class],@"expiredData" : [PZShopCarRecommendProduct class]};
}
@end

@implementation PZShopCarRecommenData
+ (NSDictionary *)objectClassInArray{
    return @{@"products" : [PZShopCarRecommendProduct class]};
}

@end

@implementation PZShopCarRecommendProduct



@end
