//
//  PZShopCarValidCellModel.h
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZShopCarCellStateModel.h"
#import "PZShopCarModel.h"

@interface PZShopCarValidCellModel : NSObject

@property (nonatomic, assign) NSInteger propertyId;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, strong) NSURL *imgUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, strong, readwrite) PZShopCarCellStateModel *state;

/// 替换product模型
- (void)replaceProductWithModel:(PZShopCarProduct *)product;
- (void)changeCount:(NSInteger)count;

- (instancetype)initWithProduct:(PZShopCarProduct *)product;

@end
