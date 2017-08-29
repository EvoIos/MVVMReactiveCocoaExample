//
//  PZShopCarValidHeaderView.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarValidHeaderView.h"
#import "PZShopCarHeader.h"

@interface PZShopCarValidHeaderView()
@property (nonatomic,strong) UIButton *markButton;
@property (nonatomic,strong) UIImageView *logoImgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *editButton;
@end

@implementation PZShopCarValidHeaderView
- (void)prepareForReuse {
    [super prepareForReuse];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self setupUI];
    
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(id x) {
        @strongify(self);
        self.titleLabel.text = self.viewModel.title;
        [self.logoImgView sd_setImageWithURL:self.viewModel.logoUrl];
        self.markButton.selected = self.viewModel.state.isMarked;
        self.markButton.rac_command = self.viewModel.markCommand;
        self.editButton.rac_command = self.viewModel.editCommand;
        
        switch (self.viewModel.state.editedState) {
            case PZShopCarEditStateTypeNormal: {
                self.editButton.hidden = NO;
                self.editButton.selected = NO;
            }
                break;
            case PZShopCarEditStateTypeEditing: {
                self.editButton.hidden = NO;
                self.editButton.selected = YES;
            }
                break;
            case PZShopCarEditStateTypeEditALl: {
                self.editButton.hidden = YES;
                self.editButton.selected = NO;
            }
                break;
            default:
                break;
        }
    }];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    [self addGestureRecognizer:tap];
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.markButton = ({
        UIButton *tmpBtn = [[UIButton alloc] init];
        [tmpBtn setImage:[UIImage imageNamed:PZShopCarDeSelectImageName] forState:UIControlStateNormal];
        [tmpBtn setImage:[UIImage imageNamed:PZShopCarSelectImageName] forState:UIControlStateSelected];
        tmpBtn.backgroundColor = [UIColor clearColor];
        tmpBtn;
    });
    [self addSubview:self.markButton];
    [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self);
        make.width.mas_equalTo(40);
    }];
    
    self.logoImgView = ({
        UIImageView *tmpImgView = [[UIImageView alloc] init];
        tmpImgView.contentMode = UIViewContentModeScaleToFill;
        tmpImgView.clipsToBounds = YES;
        tmpImgView;
    });
    [self addSubview:self.logoImgView];
    [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.markButton.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    self.titleLabel = ({
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.textColor = CustomBlackColor;
        tmpLabel.font = [UIFont systemFontOfSize:15];
        tmpLabel.numberOfLines = 2;
        tmpLabel.textAlignment = NSTextAlignmentLeft;
        tmpLabel;
    });
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImgView.mas_right).offset(4);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.bottom.mas_equalTo(self);
    }];
    
    self.editButton = ({
        UIButton *tmpBtn = [[UIButton alloc] init];
        [tmpBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [tmpBtn setTitle:@"完成" forState:UIControlStateSelected];
        [tmpBtn setTitleColor:CustomBlackColor forState:UIControlStateNormal];
        tmpBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        tmpBtn.backgroundColor = [UIColor whiteColor ];
        tmpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        tmpBtn;
    });
    [self addSubview:self.editButton];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.bottom.top.mas_equalTo(self);
    }];
    
    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = CustomGrayColor;
    [self addSubview:separatorView];
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

@end
