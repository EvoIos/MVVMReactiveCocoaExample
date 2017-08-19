//
//  PZShopCarModel.h
//  MVVMReactiveCocoaExample
//
//  Created by zhenglanchun on 2017/8/19.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZBaseResponseModel.h"

@class PZShopCarData,PZShopCarProduct;
@interface PZShopCarModel : PZBaseResponseModel
@property (nonatomic, strong) NSArray <PZShopCarData *>* data;
@end

@interface PZShopCarData : NSObject
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSArray <PZShopCarProduct *>* products;
@property (nonatomic, strong) NSString * shopId;
@property (nonatomic, strong) NSString * shopName;
@end

@interface PZShopCarProduct : NSObject
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, assign) NSInteger inventory;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger propertyId;
@property (nonatomic, strong) NSString * propertyTitle;
@property (nonatomic, strong) NSString * title;
@end
