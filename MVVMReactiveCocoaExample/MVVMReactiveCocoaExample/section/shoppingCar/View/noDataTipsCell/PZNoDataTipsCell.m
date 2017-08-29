//
//  PZNoDataTipsCell.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/29.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZNoDataTipsCell.h"
#import "PZShopCarHeader.h"

@implementation PZNoDataTipsCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        UIImageView *imgView =  ({
            UIImageView *tmpImgView = [[UIImageView alloc] init];
            tmpImgView.contentMode = UIViewContentModeCenter;
            tmpImgView.image = [UIImage imageNamed:@"空购物车"];
            tmpImgView;
        });
        [self addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        UILabel *tipsLabel =  ({
            UILabel *tmpLabel =[UILabel new];
            tmpLabel.font = [UIFont systemFontOfSize:13];
            tmpLabel.text = @"购物车竟然是空的！";
            tmpLabel.textColor = PZShopCarGrayColor;
            tmpLabel.backgroundColor = [UIColor clearColor];
            tmpLabel.textAlignment = NSTextAlignmentCenter;
            tmpLabel;
        });
        [self addSubview:tipsLabel];
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).offset(7);
            make.top.equalTo(imgView.mas_bottom).offset(8);
        }];

    }
    return self;
}

@end
