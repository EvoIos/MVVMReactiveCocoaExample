//
//  PZShopCarValidCell.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarValidCell.h"
#import "PZShopCarHeader.h"

@interface PZShopCarValidCell()

@property (nonatomic,strong) NSString *home;
@property (nonatomic,strong) UIButton *markButton;
@property (nonatomic,strong) UIImageView *coverImgView;
@property (nonatomic,strong) PZShopCarNormalStateView *defaultView;
@property (nonatomic,strong) PZShopCarEditedStateView *editingView;
@property (nonatomic,strong) UIButton *deleteButton;

@end

@implementation PZShopCarValidCell
- (void)prepareForReuse {
    [super prepareForReuse];
}

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self setupUI];
    
    @weakify(self);
    [RACObserve(self, viewModel)
     subscribeNext:^(id x) {
         @strongify(self);
         [self.coverImgView sd_setImageWithURL:self.viewModel.imgUrl placeholderImage:nil];
         self.defaultView.title = self.viewModel.title;
         self.defaultView.subTitle = self.viewModel.subTitle;
         self.defaultView.price = self.viewModel.price;
         self.defaultView.count = self.viewModel.count;
         self.editingView.subTitle = self.viewModel.subTitle;
         self.editingView.currentCount = self.viewModel.count;
         self.editingView.max = self.viewModel.max;
         self.markButton.selected = self.viewModel.state.isMarked;
         self.markButton.rac_command = self.viewModel.markCommand;
         
         switch (self.viewModel.state.editedState) {
             case PZShopCarEditStateTypeNormal: {
                 self.defaultView.hidden = NO;
                 self.editingView.hidden = YES;
                 self.canSwiped = YES;
             }
                 break;
             case PZShopCarEditStateTypeEditing: {
                 self.defaultView.hidden = YES;
                 self.editingView.hidden = NO;
                 self.editingView.isShowEditButton = YES;
                 self.canSwiped = NO;
             }
                 break;
             case PZShopCarEditStateTypeEditALl: {
                 self.defaultView.hidden = YES;
                 self.editingView.hidden = NO;
                 self.editingView.isShowEditButton = NO;
                 self.canSwiped = NO;
             }
                 break;
         }
     }];
    
    self.editingView.deleteAction = ^{
        @strongify(self);
        if (self.deleteOneProduct) {
            self.deleteOneProduct();
        }
    };
    
    self.zlc_delete = ^{
        @strongify(self);
        if (self.deleteOneProduct) {
            self.deleteOneProduct();
        }
    };
    self.editingView.tapDownArrowButton = ^{
        @strongify(self);
        if (self.tapDownArrowButton) {
            self.tapDownArrowButton();
        }
    };
    self.editingView.changeShoppingCount = ^(PZCalculationStyle style, NSInteger currentValue) {
        @strongify(self);
        if (self.changeShoppingCount) {
            self.changeShoppingCount(style, currentValue);
        }
    };
    self.editingView.didBeginEditing = ^(UITextField *textField) {
        @strongify(self);
        if (self.didBeginEditing) {
            self.didBeginEditing(textField,self);
        }
    };
    
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.markButton = ({
        UIButton *tmpBtn = [[UIButton alloc] init];
        [tmpBtn setImage:[UIImage imageNamed:PZShopCarDeSelectImageName] forState:UIControlStateNormal];
        [tmpBtn setImage:[UIImage imageNamed:PZShopCarSelectImageName] forState:UIControlStateSelected];
        tmpBtn.backgroundColor = [UIColor whiteColor];
        tmpBtn;
    });
    [self addSubview:self.markButton];
    [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self);
        make.width.mas_equalTo(40);
    }];
    
    self.coverImgView = ({
        UIImageView *tmpImgView = [[UIImageView alloc] init];
        tmpImgView.contentMode = UIViewContentModeScaleAspectFill;
        tmpImgView.clipsToBounds = YES;
        tmpImgView.image = [UIImage imageNamed:@""];
        tmpImgView.backgroundColor = HEXCOLOR(0xF0F0F0);
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
    
    self.defaultView = [PZShopCarNormalStateView new];
    [self addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.coverImgView);
        make.left.equalTo(self.coverImgView.mas_right);
        make.right.equalTo(self.mas_right).offset(0);
    }];
    
    self.editingView = [PZShopCarEditedStateView new];
    self.editingView.hidden = YES;
    [self addSubview:self.editingView];
    [self.editingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self);
        make.left.equalTo(self.coverImgView.mas_right);
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

#pragma mark - event response

- (void)endEditing {
    [self.editingView endEditing];
}

@end
