//
//  PZProductListViewController.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/10.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZProductListViewController.h"
#import "PZProductListViewModel.h"

@interface PZProductListViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) PZProductListViewModel *viewModel;
@end

@implementation PZProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNav];
    [self configureTableView];
    [self bindViewModel];

}

- (void)bindViewModel {
    @weakify(self);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[self.viewModel.fetchDataCommand execute:nil]
     subscribeNext:^(id x) {
          DLog(@"there");
          @strongify(self);
          [MBProgressHUD hideHUDForView:self.view animated:YES];
      }];
    [self.viewModel.fetchDataCommand.errors subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD showError:@"发生错误了！" toView:self.view];
    }];
    [RACObserve(self, viewModel.productLists) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)configureNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"购买"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(buy)];
}

- (void)configureTableView {
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)buy {
    DLog(@"buy");
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.productLists.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.productLists[section].products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PZDefaultProductListProduct *product = self.viewModel.productLists[indexPath.section].products[indexPath.row];
    BOOL isSelected = self.viewModel.selectedDic[indexPath].boolValue;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = product.title ;
    cell.detailTextLabel.text = product.propertyTitle;
    cell.accessoryType = isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    [[self.viewModel.selectCommand execute:indexPath] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    return _tableView;
}

- (PZProductListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [PZProductListViewModel new];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
