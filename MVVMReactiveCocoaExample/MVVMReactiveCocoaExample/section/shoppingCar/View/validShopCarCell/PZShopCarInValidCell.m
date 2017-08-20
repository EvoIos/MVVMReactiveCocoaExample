//
//  PZShopCarInValidCell.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarInValidCell.h"

@interface PZShopCarInValidCell()
@property (nonatomic,strong) UIButton *markButton;
@property (nonatomic,strong) UIImageView *coverImgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UIButton *findButton;
@end

@implementation PZShopCarInValidCell
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil;}
    
    [self setupUI];
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(id x) {
        @strongify(self);
        [self.coverImgView sd_setImageWithURL:self.viewModel.imgUrl placeholderImage:nil];
        self.titleLabel.text = self.viewModel.title;
        self.subTitleLabel.text = self.viewModel.subTitle;
    }];
    
    
    self.zlc_delete = ^{
        @strongify(self);
        if (self.deleteOneProduct) {
            self.deleteOneProduct();
        }
    };
    
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.markButton = ({
        UIButton *tmpBtn = [[UIButton alloc] init];
        [tmpBtn setTitle:@"失效" forState:UIControlStateNormal];
        tmpBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [tmpBtn setTintColor:[UIColor whiteColor]];
        tmpBtn.layer.cornerRadius = 8;
        tmpBtn.backgroundColor = CustomGrayColor;
        tmpBtn.userInteractionEnabled = NO;
        tmpBtn;
    });
    [self addSubview:self.markButton];
    [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.equalTo(self.mas_left).offset(2);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(36);
    }];
    
    self.coverImgView = ({
        UIImageView *tmpImgView = [[UIImageView alloc] init];
        tmpImgView.contentMode = UIViewContentModeScaleAspectFill;
        tmpImgView.image = [UIImage imageNamed:@""];
        tmpImgView;
    });
    [self addSubview:self.coverImgView];
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(40);
        make.centerY.equalTo(self.mas_centerY);
        make.top.equalTo(self.mas_top).offset(6);
        make.bottom.equalTo(self.mas_bottom).offset(-6);
        make.width.mas_equalTo(self.coverImgView.mas_height);
    }];
    
    UIView *defaultView = [self createDefaultView];
    [self addSubview:defaultView];
    [defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.coverImgView);
        make.left.equalTo(self.coverImgView.mas_right);
        make.right.equalTo(self.mas_right).offset(0);
    }];
    
    self.findButton = ({
        UIButton *tmpBtn = [[UIButton alloc] init];
        [tmpBtn addTarget:self action:@selector(findAction) forControlEvents:UIControlEventTouchUpInside];
        [tmpBtn setTitle:@"找相似" forState:UIControlStateNormal];
        [tmpBtn setTitleColor:DefaultNavigationBarTintColor forState:UIControlStateNormal];
        tmpBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        tmpBtn.backgroundColor = [UIColor whiteColor];
        tmpBtn.layer.borderColor = DefaultNavigationBarTintColor.CGColor;
        tmpBtn.layer.borderWidth = 0.6;
        tmpBtn.layer.cornerRadius = 15;
        tmpBtn;
    });
    [self addSubview:self.findButton];
    [self.findButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    
    UIView *lineView = ({
        UIView *tmpView = [UIView new];
        tmpView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        tmpView;
    });
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(self);
        make.left.equalTo(self.coverImgView.mas_right);
        make.height.mas_equalTo(0.8);
    }];
}

- (UIView *)createDefaultView {
    UIView *tmpView = ({
        UIView *tmpView = [UIView new];
        tmpView.backgroundColor = [UIColor whiteColor];
        tmpView;
    });
    
    self.titleLabel = ({
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.textColor = CustomGrayColor;
        tmpLabel.font = [UIFont systemFontOfSize:15];
        tmpLabel.numberOfLines = 2;
        tmpLabel.textAlignment = NSTextAlignmentLeft;
        tmpLabel;
    });
    [tmpView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tmpView.mas_left).offset(8);
        make.top.mas_equalTo(tmpView);
        make.right.equalTo(tmpView.mas_right).offset(-15);
        make.height.mas_equalTo(37);
    }];
    
    self.subTitleLabel = ({
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.textColor =  CustomBlackColor;
        tmpLabel.font = [UIFont systemFontOfSize:13];
        tmpLabel.numberOfLines = 1;
        tmpLabel.textAlignment = NSTextAlignmentLeft;
        tmpLabel;
    });
    [tmpView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tmpView.mas_left).offset(8);
        make.bottom.equalTo(tmpView.mas_bottom).offset(-8);
        make.right.equalTo(tmpView.mas_right).offset(-15);
        make.height.mas_equalTo(15);
    }];
    
    return tmpView;
}

- (void)findAction {
    if  (self.findSimilarProduct) {
        self.findSimilarProduct();
    }
}

@end
