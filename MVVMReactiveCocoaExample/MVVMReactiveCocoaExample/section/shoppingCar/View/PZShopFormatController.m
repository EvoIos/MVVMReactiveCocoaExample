//
//  PZShopFormatController.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/29.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopFormatController.h"
#import "PZShopCarFormatCell.h"
#import "PZShopFormatViewModel.h"
#import "PZShopCarFormatTopView.h"
#import "PZShopCarHeader.h"
#import "PZShopFormatPresentController.h"

@interface PZShopFormatController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic,assign) NSInteger selectedRow;
@property (nonatomic,strong) PZShopFormatViewModel *viewModel;

@property (nonatomic,strong) PZShopCarFormatTopView  *topView;
@property (nonatomic,strong) UIButton *confirmButton;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation PZShopFormatController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    self.viewModel = [PZShopFormatViewModel new];
    @weakify(self);
    [[self.viewModel.fetchDataCommand execute:@(self.productId)] subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
        [self updateTopView];
    }];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.topView = [PZShopCarFormatTopView new];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    self.confirmButton = ({
        UIButton *tmpBtn = [[UIButton alloc] init];
        [tmpBtn setTitle:@"确定" forState:UIControlStateNormal];
        [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tmpBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        tmpBtn.backgroundColor = PZShopCarRedColor;
        tmpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        tmpBtn;
    });
    [self.view addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.confirmButton.mas_top);
        make.top.equalTo(self.topView.mas_bottom);
    }];
    @weakify(self);
    [[self.topView.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
    [[self.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self dismissViewControllerAnimated:YES completion:nil];
         if (self.callBack) {
             self.callBack(self.viewModel.datas[self.selectedRow]);
         }
     }];
}

- (void)updateTopView {
    PZShopFormatData *data = self.viewModel.datas[self.selectedRow];
    self.topView.imgUrl = data.img;
    self.topView.title = data.propertyTitle;
    self.topView.inventoryStr = [NSString stringWithFormat:@"库存%ld件",data.inventory];
}

#pragma mark - UICollectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PZShopCarFormatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PZShopCarFormatCell" forIndexPath:indexPath];
    cell.title = self.viewModel.datas[indexPath.row].propertyTitle;
    cell.buttonSelected = self.selectedRow == indexPath.row;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel sizeForItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = indexPath.row;
    [self updateTopView];
    [self.collectionView reloadData];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    PZShopFormatPresentController *presentVC = [[PZShopFormatPresentController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    return presentVC;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[PZShopFormatPresentAnimation alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[PZShopFormatDismissedAnimation alloc] init];;
}


#pragma mark - getters and setters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat space = 15;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = space;
        flowLayout.minimumLineSpacing = space;
        flowLayout.sectionInset = UIEdgeInsetsMake(space, space, space, space);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[PZShopCarFormatCell class] forCellWithReuseIdentifier:@"PZShopCarFormatCell"];
    }
    return _collectionView;
}
@end
