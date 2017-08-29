//
//  PZShopFormatModel.h
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/29.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZBaseResponseModel.h"

@class PZShopFormatData;
@interface PZShopFormatModel : PZBaseResponseModel
@property (nonatomic,strong) NSArray <PZShopFormatData *>* data;
@end

@interface PZShopFormatData : NSObject

@property (nonatomic, strong) NSString * img;
@property (nonatomic, assign) NSInteger inventory;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger propertyId;
@property (nonatomic, strong) NSString * propertyTitle;
@property (nonatomic, strong) NSString * title;

@end
