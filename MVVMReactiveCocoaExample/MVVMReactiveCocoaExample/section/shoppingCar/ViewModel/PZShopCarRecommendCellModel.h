//
//  PZShopCarRecommendCellModel.h
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/21.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZShopCarRecommendModel.h"

@interface PZShopCarRecommendCellModel : NSObject
@property (nonatomic, strong) NSURL *imgUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSInteger productId;

- (instancetype)initWithProduct:(PZShopCarRecommendProduct *)product;
@end
