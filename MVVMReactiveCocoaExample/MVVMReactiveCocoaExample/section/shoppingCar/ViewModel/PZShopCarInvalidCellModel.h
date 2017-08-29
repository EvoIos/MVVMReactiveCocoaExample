//
//  PZShopCarInvalidCellModel.h
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZShopCarModel.h"

@interface PZShopCarInvalidCellModel : NSObject
@property (nonatomic, strong) NSURL *imgUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger productType;
@property (nonatomic, assign) NSInteger propertyId;

- (instancetype)initWithModel:(PZShopCarProduct *)product;

@end
