//
//  PZShopCarHeaderViewModel.h
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZShopCarModel.h"
#import "PZShopCarCellStateModel.h"
#import "PZShopCarStateEnum.h"
#import "PZShopCarRecommendModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface PZShopCarHeaderViewModel : NSObject
@property (nonatomic,copy)      NSString *title;
@property (nonatomic,strong)    NSURL *logoUrl;
@property (nonatomic,assign)    NSInteger shopId;
@property (nonatomic,strong)    NSString *localImgName;

@property (nonatomic,strong)    PZShopCarCellStateModel *state;

- (instancetype)initWithShopCarData:(PZShopCarData *)data;

- (instancetype)initWithShopCarRecommendData:(PZShopCarRecommendData *)data;

- (instancetype)initWithTitle:(NSString *)title;
@end
NS_ASSUME_NONNULL_END
