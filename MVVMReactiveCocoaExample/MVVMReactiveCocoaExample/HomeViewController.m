//
//  HomeViewController.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/9.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "HomeViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PZShopCarViewController.h"
#import "PZNetApiManager.h"


@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *info;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor;
    self.title = @"ReactiveCocoaExample";
    [self configureTableView];
}

- (void)configureTableView {
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = DefaultBackgroundColor;
}


#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.info.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.backgroundColor = DefaultBackgroundColor;
        cell.textLabel.textColor = DefaultTextLabelColor;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.info[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self generateShopCarInfo];
}

- (void)generateShopCarInfo {
    [MBProgressHUD showHUDAddedTo:self.view];
    [ApiManager addShopCarWithParams:@{} handleBlock:^(PZBaseResponseModel * _Nullable model, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (model.code == 0) {
            PZShopCarViewController *shopCar = [PZShopCarViewController new];
            [self.navigationController pushViewController:shopCar animated:YES];
        } else {
            [MBProgressHUD showError:@"报错了，稍后再试！" toView:self.view];
        }
    }];
}

#pragma mark - getter and setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    return _tableView;
}

- (NSArray *)info {
    if (!_info) {
        _info = @[@"购物车"];
    }
    return _info;
}

@end
