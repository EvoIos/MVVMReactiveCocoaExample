//
//  PZShopCarSettlementView.h
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/21.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZShopCarSettlementViewModel.h"

@interface PZShopCarSettlementView : UIView

@property (nonatomic, assign) BOOL marked;

@property (nonatomic, strong) RACCommand *markCommand;

@end
