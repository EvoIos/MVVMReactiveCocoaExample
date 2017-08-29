//
//  PZShopCarNormalStateView.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarNormalStateView.h"
#import "PZShopCarHeader.h"
#import "NSString+MoneyStyle.h"

@interface PZShopCarNormalStateView()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *countLabel;
@end

@implementation PZShopCarNormalStateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel = ({
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.textColor = PZShopCarBlackColor;
        tmpLabel.font = [UIFont systemFontOfSize:15];
        tmpLabel.numberOfLines = 2;
        tmpLabel.textAlignment = NSTextAlignmentLeft;
        tmpLabel;
    });
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.mas_equalTo(self);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(37);
    }];
    
    self.subTitleLabel = ({
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.textColor =  PZShopCarGrayColor;
        tmpLabel.font = [UIFont systemFontOfSize:13];
        tmpLabel.numberOfLines = 1;
        tmpLabel.textAlignment = NSTextAlignmentLeft;
        tmpLabel;
    });
    [self addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(15);
    }];
    
    self.priceLabel = ({
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.textColor =  PZShopCarRedColor;
        tmpLabel.font = [UIFont systemFontOfSize:13];
        tmpLabel.numberOfLines = 1;
        tmpLabel.textAlignment = NSTextAlignmentLeft;
        tmpLabel;
    });
    [self addSubview:self.priceLabel];
    
    self.countLabel = ({
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.textColor =  PZShopCarGrayColor;
        tmpLabel.font = [UIFont systemFontOfSize:15];
        tmpLabel.numberOfLines = 1;
        tmpLabel.textAlignment = NSTextAlignmentRight;
        tmpLabel;
    });
    [self addSubview:self.countLabel];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.right.mas_greaterThanOrEqualTo(self.countLabel.mas_left).offset(2);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(15);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(15);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleLabel.text = _title;
}
-(void)setSubTitle:(NSString *)subTitle {
    _subTitle = [subTitle copy];
    self.subTitleLabel.text = _subTitle;
}
- (void)setPrice:(CGFloat)price {
    _price = price;
    [self setMoneyStyleWithMoney:price];
}
- (void)setCount:(NSInteger)count {
    _count = count;
    self.countLabel.text = [NSString stringWithFormat:@"x%ld",count];
}

- (void)setMoneyStyleWithMoney:(CGFloat)money {
    self.priceLabel.attributedText = [NSString differentFontWithMoney:money moneyFont:[UIFont systemFontOfSize:13] integerFont:[UIFont systemFontOfSize:15] decimalPointFont:[UIFont systemFontOfSize:11]];
}

@end
