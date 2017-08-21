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
@property (nonatomic,strong) RACCommand *markCommand;
@property (nonatomic,strong) RACCommand *deleteAllCommand;
@property (nonatomic,strong) RACCommand *saveCommand;
@property (nonatomic,strong) RACCommand *submitCommand;

@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) NSInteger count;

@property (nonatomic,assign,getter=isEditedAll) BOOL editedAll;
@property (nonatomic,assign,getter=isMarkedAll) BOOL markedAll;
@end
