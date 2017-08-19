//
//  PZShopCarViewController.m
//  MVVMReactiveCocoaExample
//
//  Created by zhenglanchun on 2017/8/18.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarViewController.h"
#import "PZShopCarViewModel.h"

@interface PZShopCarViewController ()
@property (nonatomic,strong) PZShopCarViewModel *viewModel;
@end

@implementation PZShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"购物车";
    
    self.viewModel = [PZShopCarViewModel new];
    
    [self.viewModel.fetchDataCommand execute:nil];
    
}


@end
