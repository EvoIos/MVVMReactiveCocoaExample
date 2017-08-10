//
//  PZProductListViewModel.h
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/10.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZShoppingCarHeader.h"
#import "PZDefaultProductListModel.h"

@interface PZProductListViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray <PZDefaultProductListData *> *productLists;
@property (nonatomic, strong, readonly) NSDictionary <NSIndexPath *, NSNumber *>*selectedDic;

@property (nonatomic, strong, readonly) RACCommand *fetchDataCommand;
/// input: NSIndexPath *
@property (nonatomic, strong, readonly) RACCommand *selectCommand;

@end
