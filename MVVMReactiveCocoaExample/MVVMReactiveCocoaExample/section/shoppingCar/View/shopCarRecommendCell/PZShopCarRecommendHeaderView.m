//
//  PZShopCarRecommendHeaderView.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/21.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarRecommendHeaderView.h"
#import "PZShopCarHeader.h"

@interface PZShopCarRecommendHeaderView()
@property (nonatomic,strong) UIImageView *thumbImgVIew;
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation PZShopCarRecommendHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        @weakify(self);
        [RACObserve(self, viewModel) subscribeNext:^(id x) {
            @strongify(self);
            self.titleLabel.text = self.viewModel.title;
            if  (self.viewModel.localImgName.length == 0) {
                self.thumbImgVIew.contentMode = UIViewContentModeScaleAspectFill;
                [self.thumbImgVIew sd_setImageWithURL:self.viewModel.logoUrl placeholderImage:nil];
            } else {
                self.thumbImgVIew.contentMode = UIViewContentModeCenter;
                self.thumbImgVIew.image = [UIImage imageNamed:self.viewModel.localImgName];
            }
        }];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *spaceView = ({
        UIView *tmpView = [UIView new];
        tmpView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        tmpView;
    });
    [self addSubview:spaceView];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
    self.thumbImgVIew = ({
        UIImageView *tmpImgView = [[UIImageView alloc] init];
        tmpImgView.contentMode = UIViewContentModeScaleToFill;
        tmpImgView.backgroundColor = [UIColor clearColor];
        tmpImgView;
    });
    [self addSubview:self.thumbImgVIew];
    [self.thumbImgVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(16);
        make.bottom.equalTo(self.mas_bottom).offset(-6);
        make.left.equalTo(self.mas_left).offset(8);
        make.width.equalTo(self.thumbImgVIew.mas_height);
    }];
    
    self.titleLabel = ({
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.textColor = PZShopCarBlackColor;
        tmpLabel.font = [UIFont systemFontOfSize:16];
        tmpLabel.textAlignment = NSTextAlignmentLeft;
        tmpLabel;
    });
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thumbImgVIew.mas_right).offset(8);
        make.top.mas_equalTo(self.thumbImgVIew.mas_top);
        make.bottom.mas_equalTo(self.thumbImgVIew.mas_bottom);
    }];
}


@end
