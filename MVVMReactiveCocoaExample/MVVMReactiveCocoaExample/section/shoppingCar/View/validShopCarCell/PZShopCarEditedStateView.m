//
//  PZShopCarEditedStateView.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarEditedStateView.h"

@interface PZShopCarEditedStateView()
@property (nonatomic,strong) PZCalculationView *amountView;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UIButton *downArrowButton;
@property (nonatomic,strong) UIImageView *downArrowImgView;
@end

@implementation PZShopCarEditedStateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self blockAction];
    }
    return self;
}

- (void)setupUI {
    self.amountView = [PZCalculationView new];
    self.amountView.borderColor = [UIColor clearColor];
    [self addSubview:self.amountView];
    
    self.deleteButton = ({
        UIButton *tmpBtn = [[UIButton alloc] init];
        [tmpBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [tmpBtn setTitle:@"删除" forState:UIControlStateNormal];
        [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tmpBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        tmpBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:58/255.0 blue:58/255.0 alpha:1];
        tmpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        tmpBtn;
    });
    [self addSubview:self.deleteButton];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self);
        make.width.mas_equalTo(55);
    }];
    [self.amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.deleteButton.mas_left).offset(-10);
        make.left.equalTo(self.mas_left).offset(8);
        make.height.mas_equalTo(24);
    }];
    
    self.downArrowImgView = ({
        UIImageView *tmpImgView = [[UIImageView alloc] init];
        tmpImgView.contentMode = UIViewContentModeScaleToFill;
        tmpImgView.image = [UIImage imageNamed:@"向下"];
        tmpImgView;
    });
    [self addSubview:self.downArrowImgView];
    [self.downArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.right.equalTo(self.deleteButton.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    self.subTitleLabel = ({
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.textColor =  CustomGrayColor;
        tmpLabel.font = [UIFont systemFontOfSize:13];
        tmpLabel.numberOfLines = 1;
        tmpLabel.textAlignment = NSTextAlignmentLeft;
        tmpLabel;
    });
    self.subTitleLabel.text = @"黑、白、美黑；36";
    [self addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.right.equalTo(self.downArrowImgView.mas_left).offset(-2);
        make.height.mas_equalTo(22);
    }];
    
    self.downArrowButton = ({
        UIButton *tmpBtn = [[UIButton alloc] init];
        [tmpBtn addTarget:self action:@selector(downArrowAction:) forControlEvents:UIControlEventTouchUpInside];
        [tmpBtn setTitle:@"" forState:UIControlStateNormal];
        tmpBtn.backgroundColor = [UIColor clearColor];
        tmpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        tmpBtn;
    });
    [self addSubview:self.downArrowButton];
    [self.downArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountView.mas_bottom).offset(2);
        make.left.bottom.mas_equalTo(self);
        make.right.equalTo(self.deleteButton.mas_left).offset(-10);
    }];
}

- (void)blockAction {
    __weak typeof(self) weakSelf = self;
    self.amountView.changeShoppingCount = ^(PZCalculationStyle style, NSInteger currentValue) {
        if  (weakSelf.changeShoppingCount) {
            weakSelf.changeShoppingCount(style, currentValue);
        }
    };
    self.amountView.didBeginEditing = ^(UITextField *textField) {
        if  (weakSelf.didBeginEditing) {
            weakSelf.didBeginEditing(textField);
        }
    };
}

#pragma mark - event response

- (void)deleteAction:(UIButton *)sender {
    if  (self.deleteAction) {
        self.deleteAction();
    }
}

- (void)downArrowAction:(UIButton *)sender {
    if  (self.tapDownArrowButton) {
        self.tapDownArrowButton();
    }
}

- (void)setIsShowEditButton:(BOOL)isShowEditButton {
    _isShowEditButton = isShowEditButton;
    if (isShowEditButton) {
        [self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(self);
            make.width.mas_equalTo(55);
        }];
    } else {
        [self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(self);
            make.width.mas_equalTo(0);
        }];
    }
}

- (void)setCurrentCount:(NSUInteger)currentCount {
    _currentCount = currentCount;
    _amountView.currentCount = currentCount;
}

- (void)setMax:(NSUInteger)max {
    _max = max;
    _amountView.max = max;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    self.subTitleLabel.text = self.subTitle;
}

- (void)setIsMarked:(BOOL)isMarked {
    _isMarked = isMarked;
    
}

- (void)endEditing {
    [self.amountView endEditing];
}

@end
