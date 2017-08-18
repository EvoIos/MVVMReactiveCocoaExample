//
//  PZDefaultProductListModel.h
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/10.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZBaseResponseModel.h"

@class PZDefaultProductListData,PZDefaultProductListProduct,PZDefaultProductListProperty;
@interface PZDefaultProductListModel : PZBaseResponseModel
@property (nonatomic, strong) NSArray <PZDefaultProductListData *>* data;
@end

@interface PZDefaultProductListData : NSObject
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSArray <PZDefaultProductListProduct *>* products;
@property (nonatomic, strong) NSString * shopId;
@property (nonatomic, strong) NSString * shopName;
@end

@interface PZDefaultProductListProduct : NSObject
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, strong) NSArray <PZDefaultProductListProperty *>* propertys;
@property (nonatomic, assign) NSInteger shopId;
@end

@interface PZDefaultProductListProperty
@property (nonatomic, strong) NSString * img;
@property (nonatomic, assign) NSInteger inventory;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger propertyId;
@property (nonatomic, strong) NSString * propertyTitle;
@property (nonatomic, strong) NSString * title;
@end

