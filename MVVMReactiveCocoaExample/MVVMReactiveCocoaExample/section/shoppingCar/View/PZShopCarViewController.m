//
//  PZShopCarViewController.m
//  MVVMReactiveCocoaExample
//
//  Created by zhenglanchun on 2017/8/18.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarViewController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "PZShopCarViewModel.h"
#import "PZShopCarValidCell.h"
#import "PZShopCarInValidCell.h"
#import "PZShopCarValidHeaderView.h"
#import "PZShopCarInvalidCellModel.h"
#import "PZShopCarSettlementView.h"
#import "PZShopCarRecommendCell.h"
#import "PZShopCarRecommendHeaderView.h"
#import "PZShopCarValidFooterView.h"

@interface PZShopCarViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic, strong) PZShopCarViewModel *viewModel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PZShopCarSettlementView *settlementView;
@end

@implementation PZShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"购物车";
    [self configureRefreshView];
    [self bindViewModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fd_interactivePopDisabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.fd_interactivePopDisabled = NO;
}

- (void)configureRefreshView {
    @weakify(self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.collectionView.mj_footer resetNoMoreData];
        [self.viewModel.fetchDataCommand execute:nil];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.fetchMoreDataCommand execute:nil];
    }];
}

- (void)bindViewModel {
    @weakify(self);
    [self.viewModel.fetchDataCommand execute:nil];
    [[[self.viewModel.fetchDataCommand.executing skip:1] not]
     subscribeNext:^(id x) {
         @strongify(self)
         DLog(@"fetch Data herellll: %@",x);
         if ([x boolValue]) { // 执行完成
             [self reloadData];
             [self.collectionView.mj_header endRefreshing];
         }
     }];
    [[[self.viewModel.fetchMoreDataCommand.executing skip:1] not]
     subscribeNext:^(id x) {
         @strongify(self)
         if ([x boolValue]) { // 执行完成
             [self.collectionView reloadData];
             [self.collectionView.mj_footer endRefreshing];
             if (!self.viewModel.isMore) {
                 [self.collectionView.mj_footer endRefreshingWithNoMoreData];
             }
         }
     }];
    [self.viewModel.fetchDataCommand.errors subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
   
    self.settlementView.markCommand = self.viewModel.markCommand;
    RAC(self,settlementView.marked) = RACObserve(self, viewModel.marked);
    RAC(self,settlementView.count) = RACObserve(self, viewModel.count);
    RAC(self,settlementView.price) = RACObserve(self, viewModel.price);
    
    [[self.viewModel.markCommand.executing not] subscribeNext:^(NSNumber * x) {
        @strongify(self);
        if ([x boolValue]) {
            [self reloadData];
        }
    }];
}

#pragma mark - UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.items.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.items[section].cellViewModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch ([self.viewModel sectionTypeForSection:indexPath.section]) {
        case PZShopCarSectionInfoTypeValidType: {
            
            PZShopCarValidCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PZShopCarValidCell" forIndexPath:indexPath];
            cell.viewModel = self.viewModel.items[indexPath.section].cellViewModels[indexPath.row];

            @weakify(self);
            [[cell.viewModel.markCommand.executionSignals
              flattenMap:^RACStream *(id value) {
                  @strongify(self);
                  NSDictionary *input = @{@"type":@"indexPath",@"indexPath":indexPath};
                  return [self.viewModel.markCommand execute:input];
              }]
              subscribeNext:^(id x) {
                  @strongify(self);
                  [self reloadData];
              }];
            return cell;
        }
        case PZShopCarSectionInfoTypeInvalidType: {
            PZShopCarInvalidCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PZShopCarInvalidCell" forIndexPath:indexPath];
            cell.viewModel = self.viewModel.items[indexPath.section].cellViewModels[indexPath.row];
            return cell;
        }
        case PZShopCarSectionInfoTypeRecommendClassType: {
            PZShopCarRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PZShopCarRecommendCell" forIndexPath:indexPath];
            cell.viewModel = self.viewModel.items[indexPath.section].cellViewModels[indexPath.row];
            return cell;
        }
        case PZShopCarSectionInfoTypeRecommendProductType: {
            PZShopCarRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PZShopCarRecommendCell" forIndexPath:indexPath];
            cell.viewModel = self.viewModel.items[indexPath.section].cellViewModels[indexPath.row];
            return cell;
        }
        default: {
            NSAssert(YES, @"不应该出现在这里");
            return [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionView" forIndexPath:indexPath];;
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    switch ([self.viewModel sectionTypeForSection:indexPath.section]) {
        case PZShopCarSectionInfoTypeValidType: {
            if ([kind isEqualToString:@"UICollectionElementKindSectionHeader"]) {
                PZShopCarValidHeaderView *header =  [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"PZShopCarValidHeaderView" forIndexPath:indexPath];
                header.viewModel = self.viewModel.items[indexPath.section].headerViewModel;
                @weakify(self);
                [[header.viewModel.markCommand.executionSignals
                 flattenMap:^RACStream *(id value) {
                     @strongify(self);
                     NSDictionary *input = @{@"type":@"section",@"section":@(indexPath.section)};
                     return [self.viewModel.markCommand execute:input];
                 }] subscribeNext:^(id x) {
                     @strongify(self);
                     [self reloadData];
                 }];
                return header;
            } else {
                PZShopCarValidFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"PZShopCarValidFooterView" forIndexPath:indexPath];
                return footer;
            }
        }
        case PZShopCarSectionInfoTypeRecommendClassType:
        case PZShopCarSectionInfoTypeRecommendProductType: {
            PZShopCarRecommendHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"PZShopCarRecommendHeaderView" forIndexPath:indexPath];
            headerView.viewModel = self.viewModel.items[indexPath.section].headerViewModel;
            return headerView;
        }
        default:
            return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewHeader" forIndexPath:indexPath];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
   return [self.viewModel insetForSectionAtIndex:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel sizeForItemAtIndexPath:indexPath];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [self.viewModel minimumLineSpacingForSectionAtIndex:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [self.viewModel minimumInteritemSpacingForSectionAtIndex:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return [self.viewModel referenceSizeForHeaderInSection:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section {
    return [self.viewModel referenceSizeForFooterInSection:section];
}

#pragma mark - reloadData

- (void)reloadData {
    [self.collectionView reloadData];
    [self.settlementView reloadData];
}

#pragma mark - setter and getter

- (PZShopCarSettlementView *)settlementView {
    if (!_settlementView) {
        _settlementView = [[PZShopCarSettlementView alloc] init];
        [self.view addSubview:_settlementView];
        [_settlementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(self.view);
            make.height.mas_equalTo(50);
        }];
        
    }
    return _settlementView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        //[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        
        if (self.settlementView) {
            [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(self.view);
                make.bottom.equalTo(self.settlementView.mas_top);
            }];
        }
        
        [_collectionView registerClass:[PZShopCarValidCell class] forCellWithReuseIdentifier:@"PZShopCarValidCell"];
        [_collectionView registerClass:[PZShopCarInvalidCell class] forCellWithReuseIdentifier:@"PZShopCarInvalidCell"];
        [_collectionView registerClass:[PZShopCarRecommendCell class] forCellWithReuseIdentifier:@"PZShopCarRecommendCell"];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                       withReuseIdentifier:@"UICollectionReusableViewHeader"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                       withReuseIdentifier:@"UICollectionReusableViewFooter"];
        [_collectionView registerClass:[PZShopCarValidHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                       withReuseIdentifier:@"PZShopCarValidHeaderView"];
        [_collectionView registerClass:[PZShopCarRecommendHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"PZShopCarRecommendHeaderView"];
        [_collectionView registerClass:[PZShopCarValidFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:@"PZShopCarValidFooterView"];
        
    }
    return _collectionView;
}

- (PZShopCarViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [PZShopCarViewModel new];
    }
    return _viewModel;
}

@end
