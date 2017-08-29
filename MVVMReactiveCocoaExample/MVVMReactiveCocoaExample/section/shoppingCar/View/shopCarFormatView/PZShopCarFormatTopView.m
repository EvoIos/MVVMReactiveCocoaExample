//
//  PZShopCarFormatTopView.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/29.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarFormatTopView.h"
#import "PZShopCarHeader.h"

@interface PZShopCarFormatTopView()
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *inventoryLabel;

@end

@implementation PZShopCarFormatTopView

// height : 80
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        
        RAC(self,titleLabel.text) = RACObserve(self, title);
        RAC(self,inventoryLabel.text) = RACObserve(self, inventoryStr);
        @weakify(self);
        [RACObserve(self, imgUrl) subscribeNext:^(id x) {
            @strongify(self);
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl]];
        }];
    
    }
    return self;
}

- (void)setupUI {
    self.imgView = ({
        UIImageView *tmpImgView = [[UIImageView alloc] init];
        tmpImgView.contentMode = UIViewContentModeScaleAspectFill;
        tmpImgView.clipsToBounds = YES;
        tmpImgView.backgroundColor = PZShopCarPlachHolderColor;
        tmpImgView;
    });
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.height.mas_equalTo(self.mas_height);
        make.width.mas_equalTo(self.imgView.mas_height);
    }];
    
    self.closeButton = ({
        UIButton *tmpBtn = [[UIButton alloc] init];
        [tmpBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        tmpBtn;
    });
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(8);
        make.right.equalTo(self.mas_right).offset(-8);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    
    self.titleLabel = ({
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.textColor = PZShopCarRedColor;
        tmpLabel.font = [UIFont systemFontOfSize:13];
        tmpLabel.textAlignment = NSTextAlignmentCenter;
        tmpLabel;
    });
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(8);
        make.top.equalTo(self.mas_top).offset(20);
        make.height.mas_equalTo(15);
    }];
    
    self.inventoryLabel = ({
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.textColor = PZShopCarGrayColor;
        tmpLabel.font = [UIFont systemFontOfSize:14];
        tmpLabel.textAlignment = NSTextAlignmentCenter;
        tmpLabel;
    });
    [self addSubview:self.inventoryLabel];
    [self.inventoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(8);
        make.top.equalTo(self.mas_top).offset(40);
        make.height.mas_equalTo(15);
    }];
    
    UIView *lineView = ({
        UIView *tmpView = [UIView new];
        tmpView.backgroundColor = PZShopCarLightGrayColor;
        tmpView;
    });
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-8);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

@end
