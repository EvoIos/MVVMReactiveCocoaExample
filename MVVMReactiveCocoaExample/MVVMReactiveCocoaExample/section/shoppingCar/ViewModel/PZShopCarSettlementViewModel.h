//
//  PZShopCarSettlementViewModel.h
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/21.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZShopCarSettlementViewModel : NSObject
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) BOOL isEditedAll;

@property (nonatomic, strong, readonly) RACCommand *saveCommand;

@property (nonatomic, strong, readonly) RACCommand *markCommand;
@end
