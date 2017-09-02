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
#import "PZShopCarHeader.h"
#import "PZShopFormatController.h"
#import "PZNoDataTipsCell.h"
#import "PZShopCarInvalidFooterView.h"
#import "RACAlertAction.h"

@interface PZShopCarViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic, strong) PZShopCarViewModel *viewModel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PZShopCarSettlementView *settlementView;
@property (nonatomic, strong) UIBarButtonItem *editItem;
@property (nonatomic, strong) UIAlertController *alertVC;
@end

@implementation PZShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
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

- (void)setupNav {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"购物车";
    UIButton *rightButton = ({
        UIButton *tmpBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [tmpBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [tmpBtn setTitle:@"完成" forState:UIControlStateSelected];
        [tmpBtn setTitleColor:DefaultTextLabelColor forState:UIControlStateNormal];
        tmpBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        tmpBtn.backgroundColor = [UIColor clearColor ];
        tmpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        tmpBtn;
    });
    self.editItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = self.editItem;
    @weakify(self);
    RAC(rightButton,selected) = RACObserve(self, viewModel.edited);
    RAC(rightButton,rac_command) = RACObserve(self, viewModel.editCommand);
    [[self.viewModel.editCommand.executing not] subscribeNext:^(id x) {
        if ([x boolValue]) {
            @strongify(self);
            [self reloadData];
        }
    }];
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton * sender) {
        sender.selected = !sender.selected;
    }];
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
         DLog(@"fetch Data: %@",x);
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
    [self.viewModel.fetchDataCommand.errors subscribeNext:^(NSError * x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:x.localizedDescription toView:self.view];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
    
    [RACObserve(self, viewModel.hasValidData) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.settlementView.hidden = !x.boolValue;
        [self.settlementView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(self.view);
            make.height.mas_equalTo(x.boolValue ? 50 : 0);
        }];
        self.navigationItem.rightBarButtonItem = x.boolValue ? self.editItem : nil;
    }];
   
    self.settlementView.deleteSignal = [RACSubject subject];
    self.settlementView.saveSignal = [RACSubject subject];
    self.settlementView.submitSignal = [RACSubject subject];
    self.settlementView.markCommand = self.viewModel.markCommand;
    
    RAC(self,settlementView.edited) = RACObserve(self, viewModel.edited);
    RAC(self,settlementView.marked) = RACObserve(self, viewModel.marked);
    RAC(self,settlementView.count) = RACObserve(self, viewModel.count);
    RAC(self,settlementView.price) = RACObserve(self, viewModel.price);
    
    [[self.viewModel.markCommand.executing not]
     subscribeNext:^(NSNumber * x) {
        @strongify(self);
        if ([x boolValue]) {
            [self reloadData];
        }
     }];
        
    [[[[self.settlementView.saveSignal
        filter:^BOOL(id value) {
            @strongify(self);
            BOOL hasMarkedInfo = [self.viewModel hasMarkedInfo];
            if (!hasMarkedInfo) {
                [MBProgressHUD showError:@"还没有选中商品哦！" toView:self.view];
            }
            return hasMarkedInfo;
        }]
       flattenMap:^RACStream *(id value) {
           @strongify(self);
           [MBProgressHUD showHUDAddedTo:self.view];
           return [self.viewModel.saveCommand execute:nil];
       }]
      flattenMap:^RACStream *(id value) {
          @strongify(self);
          return [self.viewModel.fetchDataCommand execute:nil];
      }]
     subscribeNext:^(id x) {
         @strongify(self);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD showSuccess:@"收藏成功！" toView:self.view];
     }];
    
    [self.viewModel.saveCommand.errors subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD showError:@"网络错误，请稍后再试！" toView:self.view];
    }];
    
    [[[[self.settlementView.submitSignal
        filter:^BOOL(id value) {
            @strongify(self);
            BOOL hasMarkedInfo = [self.viewModel hasMarkedInfo];
            if (!hasMarkedInfo) {
                [MBProgressHUD showError:@"还没有选中商品哦！" toView:self.view];
            }
            return hasMarkedInfo;
        }]
       flattenMap:^RACStream *(id value) {
           @strongify(self);
           [MBProgressHUD showHUDAddedTo:self.view];
           return [self.viewModel.saveCommand execute:nil];
       }]
      flattenMap:^RACStream *(id value) {
          @strongify(self);
          return [self.viewModel.fetchDataCommand execute:nil];
      }]
     subscribeNext:^(id x) {
         @strongify(self);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD showSuccess:@"提交成功！" toView:self.view];
     }];
    
    [self.viewModel.submitCommand.errors subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD showError:@"网络错误，请稍后再试！" toView:self.view];
    }];
    
    [[[[[[self.settlementView.deleteSignal
          filter:^BOOL(id value) {
              @strongify(self);
              BOOL hasMarkedInfo = [self.viewModel hasMarkedInfo];
              if (!hasMarkedInfo) {
                  [MBProgressHUD showError:@"还没有选中商品哦！" toView:self.view];
              }
              return hasMarkedInfo;
          }]
         flattenMap:^RACStream *(id value) {
             @strongify(self);
             return [self.viewModel actionWithConfirmation:^RACSignal *{
                 @strongify(self);
                 return [self showAlertVCWithTitle:@"确认要删除这些商品吗"];
             }];
        }]
        filter:^BOOL(NSNumber * value) {
            return [value boolValue];
        }]
       flattenMap:^RACStream *(id value) {
           @strongify(self);
           [MBProgressHUD showHUDAddedTo:self.view];
           NSDictionary *input = @{@"type":@"all"};
           return [self.viewModel.deleteCommand execute:input];
       }]
      flattenMap:^RACStream *(id value) {
          @strongify(self);
          return [self.viewModel.fetchDataCommand execute:nil];
      }]
     subscribeNext:^(id x) {
         @strongify(self);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD showSuccess:@"删除成功！" toView:self.view];
    }];
    
    [self.viewModel.deleteCommand.errors subscribeNext:^(NSError * error) {
       @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络错误，请稍后再试！" toView:self.view];
    }];
}

- (RACSignal *)showAlertVCWithTitle:(NSString *)title {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    RACAlertAction *confirmAction = [RACAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault];
    confirmAction.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal return:@(YES)];
    }];
    RACAlertAction *deleteAction = [RACAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel];
    deleteAction.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal return:@(NO)];
    }];
    [alertVC addAction:confirmAction];
    [alertVC addAction:deleteAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    RACSignal *resultSignals = [RACSignal
                                merge:@[ confirmAction.command.executionSignals.switchToLatest,
                                         deleteAction.command.executionSignals.switchToLatest ]];
    return resultSignals;
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
        case PZShopCarSectionInfoTypeNoneType: {
            PZNoDataTipsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PZNoDataTipsCell" forIndexPath:indexPath];
            return cell;
        }
        case PZShopCarSectionInfoTypeValidType: {
            
            PZShopCarValidCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PZShopCarValidCell" forIndexPath:indexPath];
            cell.viewModel = nil;
            PZShopCarValidCellModel *model = self.viewModel.items[indexPath.section].cellViewModels[indexPath.row];
            cell.viewModel = model;
            
            @weakify(self);
            cell.markSignal = [RACSubject subject];
            [[cell.markSignal flattenMap:^RACStream *(id value) {
                @strongify(self);
                NSDictionary *input = @{@"type":@"indexPath",
                                        @"indexPath":indexPath};
                return [self.viewModel.markCommand execute:input];
            }] subscribeNext:^(id x) { }];
            
            cell.deleteSignal = [RACSubject subject];
            [[[[[cell.deleteSignal
                flattenMap:^RACStream *(id value) {
                    @strongify(self);
                    return [self.viewModel actionWithConfirmation:^RACSignal *{
                        @strongify(self);
                        return [self showAlertVCWithTitle:@"确认要删除这件商品吗"];
                    }];
                }]
               filter:^BOOL(NSNumber * value) {
                   return [value boolValue];
               }]
              flattenMap:^RACStream *(id value) {
                  @strongify(self);
                  [MBProgressHUD showHUDAddedTo:self.view];
                  NSDictionary *input = @{@"type":@"indexPath",
                                        @"indexPath":indexPath};
                  return [self.viewModel.deleteCommand execute:input];
              }]
             flattenMap:^RACStream *(id value) {
                  @strongify(self);
                 return [self.viewModel.fetchDataCommand execute:nil];
             }]
             subscribeNext:^(id x) {
                 @strongify(self);
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [MBProgressHUD showSuccess:@"删除成功" toView:self.view ];
             }];
            
            cell.changeCountSignal = [RACSubject subject];
            [[cell.changeCountSignal
             flattenMap:^RACStream *(NSDictionary * value) {
                 @strongify(self);
                 [MBProgressHUD showHUDAddedTo:self.view];
                 NSDictionary *dic = @{@"indexPath":indexPath,
                                       @"count":value[@"currentValue"]};
                 return [self.viewModel.changeCountCommand execute:dic];
             }]
             subscribeNext:^(id x) {
                 @strongify(self);
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             } error:^(NSError *error) {
                 @strongify(self);
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [MBProgressHUD showError:@"修改失败了！" toView:self.view];
             }];
            
            cell.changePropertySignal = [RACSubject subject];
            [cell.changePropertySignal subscribeNext:^(id x) {
                @strongify(self);
                [self updatePropertyForIndexPath:indexPath];
            }];
            
            return cell;
        }
        case PZShopCarSectionInfoTypeInvalidType: {
            PZShopCarInvalidCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PZShopCarInvalidCell" forIndexPath:indexPath];
            cell.viewModel = self.viewModel.items[indexPath.section].cellViewModels[indexPath.row];
            cell.deleteSignal = [RACSubject subject];
            @weakify(self);
            [[[[[cell.deleteSignal
                 flattenMap:^RACStream *(id value) {
                     @strongify(self);
                     return [self.viewModel actionWithConfirmation:^RACSignal *{
                         @strongify(self);
                         return [self showAlertVCWithTitle:@"确认要删除这件商品吗"];
                     }];
                 }]
                filter:^BOOL(NSNumber * value) {
                    return [value boolValue];
                }]
               flattenMap:^RACStream *(id value) {
                   @strongify(self);
                   [MBProgressHUD showHUDAddedTo:self.view];
                   NSDictionary *input = @{@"type":@"indexPath",
                                           @"indexPath":indexPath};
                   return [self.viewModel.deleteCommand execute:input];
               }]
              flattenMap:^RACStream *(id value) {
                  @strongify(self);
                  return [self.viewModel.fetchDataCommand execute:nil];
              }]
             subscribeNext:^(id x) {
                 @strongify(self);
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [MBProgressHUD showSuccess:@"删除成功" toView:self.view ];
             }];
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
                     NSDictionary *input = @{@"type":@"section",
                                             @"section":@(indexPath.section)};
                     return [self.viewModel.markCommand execute:input];
                 }] subscribeNext:^(id x) { }];
                [[header.viewModel.editCommand.executionSignals
                 flattenMap:^RACStream *(id value) {
                     @strongify(self);
                     return [self.viewModel.editCommand execute:@(indexPath.section)];
                 }]
                 subscribeNext:^(id x) { }];
                return header;
            } else {
                PZShopCarValidFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"PZShopCarValidFooterView" forIndexPath:indexPath];
                return footer;
            }
        }
        case PZShopCarSectionInfoTypeInvalidType: {
            PZShopCarInvalidFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"PZShopCarInvalidFooterView" forIndexPath:indexPath];
            footerView.cleanSignal = [RACSubject subject];
            @weakify(self);
            [[[[[footerView.cleanSignal
                flattenMap:^RACStream *(id value) {
                    @strongify(self);
                    return [self.viewModel actionWithConfirmation:^RACSignal *{
                        @strongify(self);
                        return [self showAlertVCWithTitle:@"确认要清空这些商品吗"];
                    }];
                }]
               filter:^BOOL(NSNumber * value) {
                   return [value boolValue];
               }]
              flattenMap:^RACStream *(id value) {
                  @strongify(self);
                  [MBProgressHUD showHUDAddedTo:self.view];
                  NSDictionary *input = @{@"type":@"section",
                                         @"section":@(indexPath.section)};
                  return [self.viewModel.deleteCommand execute:input];
              }]
             flattenMap:^RACStream *(id value) {
                 @strongify(self);
                 return [self.viewModel.fetchDataCommand execute:nil];
             }]
             subscribeNext:^(id x) {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             }];
            
            
            return footerView;
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

#pragma mark - event

- (void)reloadData {
    [self.collectionView reloadData];
    [self.settlementView reloadData];
}

- (void)updatePropertyForIndexPath:(NSIndexPath *)indexPath {
    PZShopFormatController *formatVC = [PZShopFormatController new];
    formatVC.transitioningDelegate = formatVC;
    formatVC.modalPresentationStyle = UIModalPresentationCustom;
    PZShopCarValidCellModel *cellModel = self.viewModel.items[indexPath.section].cellViewModels[indexPath.row];
    formatVC.productId = cellModel.productId;
    @weakify(self);
    @weakify(cellModel);
    formatVC.callBack = ^(PZShopFormatData *data) {
        @strongify(self);
        @strongify(cellModel);
        
        NSDictionary *param = @{@"oldPropertyId":@(cellModel.propertyId),
                                @"newPropertyId":@(data.propertyId)
                                };
        
        NSInteger lastCount = cellModel.count;
        NSDictionary *dic = [data mj_keyValues];
        PZShopCarProduct *product = [PZShopCarProduct mj_objectWithKeyValues:dic];
        product.count = lastCount;
        
        NSDictionary *input = @{@"param":param,
                                @"product":product,
                                @"indexPath":indexPath};
        [[self.viewModel.changePropertyCommand execute:input]
         subscribeNext:^(id x) {
             @strongify(self);
             [self reloadData];
         }];
    };
    [self presentViewController:formatVC animated:YES completion:nil];
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
        
        [_collectionView registerClass:[PZNoDataTipsCell class]
            forCellWithReuseIdentifier:@"PZNoDataTipsCell"];
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
        [_collectionView registerClass:[PZShopCarInvalidFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:@"PZShopCarInvalidFooterView"];
        
    }
    return _collectionView;
}

- (PZShopCarViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [PZShopCarViewModel new];
    }
    return _viewModel;
}

- (UIAlertController *)alertVC {
    if  (!_alertVC) {
        _alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        RACAlertAction *confirmAction = [RACAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault];
        confirmAction.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal return:@(YES)];
        }];
        RACAlertAction *deleteAction = [RACAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel];
        deleteAction.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal return:@(NO)];
        }];
        [_alertVC addAction:confirmAction];
        [_alertVC addAction:deleteAction];
    }
    return _alertVC;
}

- (void)dealloc {
    DLog(@"controller dealloc: %@",self);
}
@end
