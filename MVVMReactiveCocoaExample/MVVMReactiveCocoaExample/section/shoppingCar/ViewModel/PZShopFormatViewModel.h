//
//  PZShopFormatViewModel.h
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/29.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZShopFormatViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray <PZShopFormatData *>*datas;

@property (nonatomic, strong, readonly) RACCommand *fetchDataCommand;

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
