//
//  PZShopCarInvalidFooterView.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/29.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarInvalidFooterView.h"
#import "PZShopCarHeader.h"

@interface PZShopCarInvalidFooterView()
@property (nonatomic,strong) UIButton *cleanButton;
@end

@implementation PZShopCarInvalidFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        self.cleanButton = ({
            UIButton *tmpBtn = [[UIButton alloc] init];
            [tmpBtn setBackgroundColor:[UIColor clearColor]];
            [tmpBtn setTitle:@"清空失效商品" forState:UIControlStateNormal];
            [tmpBtn setTitleColor:PZShopCarGrayColor forState:UIControlStateNormal];
            tmpBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            tmpBtn.layer.cornerRadius = 18;
            tmpBtn.layer.borderColor = PZShopCarLightGrayColor.CGColor;
            tmpBtn.layer.borderWidth = 0.5;
            tmpBtn;
        });
        [self addSubview:self.cleanButton];
        [self.cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(100, 36));
        }];
        @weakify(self);
        [[self.cleanButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (self.cleanSignal) {
                [self.cleanSignal sendNext:nil];
            }
        }];
    }
    return self;
}
@end
