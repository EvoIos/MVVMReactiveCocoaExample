//
//  PZShopCarNormalStateView.h
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZShopCarNormalStateView : UIView
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subTitle;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) NSInteger count;
@end
