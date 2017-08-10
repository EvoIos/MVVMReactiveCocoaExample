//
//  PZDefaultProductListModel.h
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/10.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PZDefaultProductListData,PZDefaultProductListProduct;
@interface PZDefaultProductListModel : NSObject
@property (nonatomic, strong) NSArray <PZDefaultProductListData *>* data;
@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, copy)   NSString *msg;
@property (nonatomic, assign) BOOL success;
@end


@interface PZDefaultProductListData : NSObject
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSArray <PZDefaultProductListProduct *>* products;
@property (nonatomic, strong) NSString * shopId;
@property (nonatomic, strong) NSString * shopName;
@end


@interface PZDefaultProductListProduct : NSObject
@property (nonatomic, strong) NSString * img;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, strong) NSString * propertyTitle;
@property (nonatomic, strong) NSString * title;
@end
