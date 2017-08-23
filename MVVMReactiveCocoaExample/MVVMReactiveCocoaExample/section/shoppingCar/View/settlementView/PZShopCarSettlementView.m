//
//  PZShopCarSettlementView.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/21.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarSettlementView.h"
#import "PZShopCarHeader.h"

@interface PZShopCarSettlementView()
@property (nonatomic,strong) UIButton *markButton;
@property (nonatomic,strong) UILabel *totalLabel;
@property (nonatomic,strong) UILabel *transportLabel;
@property (nonatomic,strong) UIButton *submitButton;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,strong) UIButton *moveToSaveButton;
@end

@implementation PZShopCarSettlementView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
   
    [self setupUI];
    
    @weakify(self);

    [RACObserve(self, markCommand) subscribeNext:^(id x) {
       @strongify(self);
        self.markButton.rac_command = self.markCommand;
    }];
    
    [RACObserve(self, marked) subscribeNext:^(id x) {
        @strongify(self);
        self.markButton.selected = self.marked;
    }];
    
//    [RACObserve(self, editedAll) subscribeNext:^(NSNumber *editedAll) {
//        @strongify(self);
//        self.deleteButton.hidden = !editedAll.boolValue;
//        self.moveToSaveButton.hidden = !editedAll.boolValue;
//        self.submitButton.hidden = editedAll.boolValue;
//        self.totalLabel.hidden = editedAll.boolValue;
//    }];
//    
//    [self.submitButton
//     rac_liftSelector:@selector(setTitle:forState:)
//     withSignals:[RACObserve(self, count) map:^id _Nullable(NSNumber * value) {
//        return [NSString stringWithFormat:@"结算(%ld)",value.integerValue];
//    }], [RACSignal return:@(UIControlStateNormal)], nil];
    
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.markButton = ({
        UIButton *tmpBtn = [[UIButton alloc] init];
        [tmpBtn setImage:[UIImage imageNamed:PZShopCarDeSelectImageName] forState:UIControlStateNormal];
        [tmpBtn setImage:[UIImage imageNamed:PZShopCarSelectImageName] forState:UIControlStateSelected];
        [tmpBtn setTitle:@" 全选" forState:UIControlStateNormal];
        [tmpBtn setTitleColor:PZShopCarBlackColor forState:UIControlStateNormal];
        tmpBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        tmpBtn.backgroundColor = [UIColor clearColor];
        tmpBtn;
    });
    [self addSubview:self.markButton];
    
    self.transportLabel = ({
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.textColor = PZShopCarGrayColor;
        tmpLabel.font = [UIFont systemFontOfSize:13];
        tmpLabel.numberOfLines = 1;
        tmpLabel.textAlignment = NSTextAlignmentCenter;
        tmpLabel;
    });
    [self addSubview:self.transportLabel];
    
    self.totalLabel = ({
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.textColor = PZShopCarBlackColor;
        tmpLabel.font = [UIFont systemFontOfSize:15];
        tmpLabel.numberOfLines = 1;
        tmpLabel.textAlignment = NSTextAlignmentRight;
        tmpLabel;
    });
    self.totalLabel.text = @"合计：￥ 0";
    [self addSubview:self.totalLabel];
    
    self.submitButton = ({
        UIButton *tmpBtn = [[UIButton alloc] init];
        [tmpBtn setTitle:@"结算(0)" forState:UIControlStateNormal];
        [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tmpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        tmpBtn.backgroundColor = PZShopCarRedColor;
        tmpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        tmpBtn;
    });
    [self addSubview:self.submitButton];
    
    self.deleteButton = ({
        UIButton *tmpBtn = [[UIButton alloc] init];
        [tmpBtn setTitle:@"删除" forState:UIControlStateNormal];
        [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tmpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        tmpBtn.backgroundColor = PZShopCarRedColor;
        tmpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        tmpBtn;
    });
    self.deleteButton.hidden = YES;
    [self addSubview:self.deleteButton];
    
    self.moveToSaveButton = ({
        UIButton *tmpBtn = [[UIButton alloc] init];
        [tmpBtn setTitle:@"移到收藏夹" forState:UIControlStateNormal];
        [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tmpBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        tmpBtn.backgroundColor = PZShopCarRedColor;
        tmpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        tmpBtn;
    });
    self.moveToSaveButton.hidden = YES;
    [self addSubview:self.moveToSaveButton];
    
    [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self);
        make.width.mas_equalTo(85);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self);
        make.width.mas_equalTo(106);
    }];
    
    [self.transportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.submitButton.mas_left).offset(-8);
        make.top.bottom.mas_equalTo(self);
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.mas_left).offset(85);
        make.right.equalTo(self.transportLabel.mas_left).offset(-8);
        make.top.bottom.mas_equalTo(self);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self);
        make.width.mas_equalTo(86);
    }];
    
    [self.moveToSaveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.right.equalTo(self.deleteButton.mas_left).offset(-1);
        make.width.mas_equalTo(90);
    }];
}

@end
