//
//  PZShopCarFormatCell.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/29.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarFormatCell.h"
#import "PZShopCarHeader.h"
#import "AssociatedBorderColorButton.h"

@interface PZShopCarFormatCell()
@property (nonatomic,strong) AssociatedBorderColorButton *titleButton;
@end

@implementation PZShopCarFormatCell

- (instancetype)initWithFrame:(CGRect)frame {
    if  (self = [super initWithFrame:frame]) {
        [self setupUI];
        
        @weakify(self);
        [RACObserve(self, title) subscribeNext:^(id x) {
            @strongify(self);
            [self.titleButton setTitle:self.title forState:UIControlStateNormal];
        }];
        RAC(self,titleButton.selected) = RACObserve(self, buttonSelected);
    }
    return self;
}

- (void)setupUI {
    self.titleButton = ({
        AssociatedBorderColorButton *tmpBtn = [[AssociatedBorderColorButton alloc] init];
        tmpBtn.userInteractionEnabled = NO;
        [tmpBtn setTitle:@"aaa" forState:UIControlStateNormal];
        [tmpBtn setTitleColor:PZShopCarGrayColor forState:UIControlStateNormal];
        [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        tmpBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        tmpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        tmpBtn;
    });
    
    [self addSubview:self.titleButton];
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

@end
