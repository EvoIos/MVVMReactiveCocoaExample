//
//  PZShopCarRecommendCell.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/21.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarRecommendCell.h"
#import "NSString+MoneyStyle.h"
#import "PZShopCarHeader.h"

@interface PZShopCarRecommendCell()
@property (nonatomic,strong) UIImageView *coverImgView;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UIButton *lookupButton;
@end

@implementation PZShopCarRecommendCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        @weakify(self);
        [RACObserve(self, viewModel) subscribeNext:^(id x) {
            @strongify(self);
            [self.coverImgView sd_setImageWithURL:self.viewModel.imgUrl placeholderImage:nil];
            self.titleLabel.text = self.viewModel.title;
            [self setMoneyStyleWithMoney:self.viewModel.price];
        }];
    }
    return self;
}

// 宽高比：0.64
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.coverImgView = ({
        UIImageView *tmpImgView = [[UIImageView alloc] init];
        tmpImgView.contentMode = UIViewContentModeScaleAspectFill;
        tmpImgView.clipsToBounds = YES;
        tmpImgView;
    });
    self.coverImgView.backgroundColor = PZShopCarLightGrayColor;
    [self addSubview:self.coverImgView];
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(self.bounds.size.width);
    }];
    
    self.titleLabel = ({
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.textColor = PZShopCarBlackColor;
        tmpLabel.font = [UIFont systemFontOfSize:16];
        tmpLabel.numberOfLines = 2;
        tmpLabel.textAlignment = NSTextAlignmentLeft;
        tmpLabel;
    });
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImgView.mas_bottom).offset(6);
        make.left.equalTo(self.mas_left).offset(8);
        make.right.equalTo(self.mas_right).offset(-8);
        make.height.mas_equalTo(40);
    }];
    
    self.priceLabel = ({
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.textColor = PZShopCarRedColor;
        tmpLabel.font = [UIFont systemFontOfSize:16];
        tmpLabel.textAlignment = NSTextAlignmentCenter;
        tmpLabel;
    });
    
    [self addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-4);
        make.left.equalTo(self.mas_left).offset(8);
        make.height.mas_equalTo(24);
    }];
    
    self.lookupButton = ({
        UIButton *tmpBtn = [[UIButton alloc] init];
        [tmpBtn addTarget:self action:@selector(lookup:) forControlEvents:UIControlEventTouchUpInside];
        [tmpBtn setTitle:@"看相似" forState:UIControlStateNormal];
        [tmpBtn setTitleColor:PZShopCarGrayColor forState:UIControlStateNormal];
        tmpBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        tmpBtn.backgroundColor = [UIColor whiteColor ];
        tmpBtn.layer.cornerRadius = 14;
        tmpBtn.layer.borderColor = PZShopCarGrayColor.CGColor;
        tmpBtn.layer.borderWidth = 0.5f;
        tmpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        tmpBtn;
    });
    [self addSubview:self.lookupButton];
    [self.lookupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-4);
        make.right.equalTo(self.mas_right).offset(-4);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(28);
    }];
    self.lookupButton.hidden = YES;
}

- (void)setMoneyStyleWithMoney:(CGFloat)money {
    self.priceLabel.attributedText = [NSString differentFontWithMoney:money moneyFont:[UIFont systemFontOfSize:13] integerFont:[UIFont systemFontOfSize:15] decimalPointFont:[UIFont systemFontOfSize:11]];
}

- (void)lookup:(UIButton *)sender {
    if  (self.findSimilarProduct) {
        self.findSimilarProduct();
    }
}

@end
