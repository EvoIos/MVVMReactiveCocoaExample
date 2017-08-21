//
//  PZShopCarRecommendModel.h
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZBaseResponseModel.h"

@class PZShopCarRecommendProduct,PZShopCarRecommendData;

@interface PZShopCarRecommendModel : PZBaseResponseModel
@property (nonatomic, strong) NSArray <PZShopCarRecommendData *>* recommendlist;
@property (nonatomic, strong) NSArray <PZShopCarRecommendProduct *>* likelist;
@end

@interface PZShopCarRecommendData : NSObject
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSArray <PZShopCarRecommendProduct *>* products;
@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, strong) NSString * shopName;
@end

@interface PZShopCarRecommendProduct : NSObject
@property (nonatomic, assign) BOOL expired;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, assign) NSInteger inventory;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger propertyId;
@property (nonatomic, strong) NSString * propertyTitle;
@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, strong) NSString * title;
@end
