//
//  PZShopFormatController.h
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/29.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZShopFormatModel.h"

@interface PZShopFormatController : UIViewController<UIViewControllerTransitioningDelegate>

@property (nonatomic,assign) NSInteger productId;
@property (nonatomic,copy) void(^callBack)(PZShopFormatData *data);

@end
