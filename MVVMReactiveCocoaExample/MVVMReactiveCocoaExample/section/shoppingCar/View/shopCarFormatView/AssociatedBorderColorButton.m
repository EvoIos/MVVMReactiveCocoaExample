//
//  PZShopCarFormatCell.h
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/29.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "AssociatedBorderColorButton.h"
#import "PZShopCarHeader.h"

@implementation AssociatedBorderColorButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.0f;
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = PZShopCarRedColor;
    } else {
        self.backgroundColor = PZShopCarPlachHolderColor;
    }
}

@end
