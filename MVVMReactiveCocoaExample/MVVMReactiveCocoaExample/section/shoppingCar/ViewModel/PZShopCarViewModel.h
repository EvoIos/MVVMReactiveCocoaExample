//
//  PZShopCarViewModel.h
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/19.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZShopCarViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *fetchDataCommand;

@end
