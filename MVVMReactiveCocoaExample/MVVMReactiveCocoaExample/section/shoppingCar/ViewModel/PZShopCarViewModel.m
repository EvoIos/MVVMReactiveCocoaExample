//
//  PZShopCarViewModel.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/19.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "PZShopCarViewModel.h"
#import "PZShopCarHeaderViewModel.h"
#import "PZShopCarInvalidCellModel.h"

@interface PZShopCarViewModel()

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign, readwrite, getter=isMore) BOOL more;

@property (nonatomic, strong, readwrite) NSArray * items;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSNumber *> *sectionTypeDictionary;
@property (nonatomic, strong, readwrite) RACCommand *fetchDataCommand;
@property (nonatomic, strong, readwrite) RACCommand *fetchMoreDataCommand;
@end

@implementation PZShopCarViewModel

- (void)initializeData {
    self.pageIndex = 0;
//    self.price = 0.0;
//    self.editedAll = NO;
//    self.markedAll = NO;
    self.more = YES;
//    
    self.sectionTypeDictionary = [@{} mutableCopy];
//    self.markedDic = @{};
    self.items = @[];
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    @weakify(self);
    
    RACSignal *fetchListSignal =  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [ApiManager shopCarListWithBlock:^(PZShopCarModel * _Nullable model, NSError * _Nullable error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                if  (model.code == 0) {
                    [subscriber sendNext:model];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:model.error];
                }
            }
        }];
        return nil;
    }];
    RACSignal *fetchRecommendListSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [ApiManager shopCarRecommendListWithParams:@{@"pageIndex":@(self.pageIndex)} handleBlock:^(PZShopCarRecommendModel * _Nullable model, NSError * _Nullable error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                if (model.code == 0) {
                    [subscriber sendNext:model];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:model.error];
                }
            }
        }];
        return nil;
    }];
    self.fetchDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self initializeData];
        return [fetchListSignal combineLatestWith:fetchRecommendListSignal];
    }];
    self.fetchMoreDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.pageIndex += 1;
        return fetchRecommendListSignal;
    }];
    
    [self.fetchDataCommand.executionSignals.switchToLatest subscribeNext:^(RACTuple * x) {
        @strongify(self)
        if (x.allObjects.count != 2) {
            return ;
        }
        PZShopCarModel *model = x.first;
        PZShopCarRecommendModel *recommendModel = x.second;
        
        NSMutableArray *tmpArray = [@[] mutableCopy];
        // valide Info
        for (PZShopCarData *data in model.data) {
            // sectionType
            self.sectionTypeDictionary[@(self.sectionTypeDictionary.count)] = @(PZShopCarSectionInfoTypeValidType);
            // cell info
            NSMutableArray *rowDatas = [@[] mutableCopy];
            for (PZShopCarProduct *product in data.products) {
                PZShopCarValidCellModel *cellModel = [[PZShopCarValidCellModel alloc] initWithProduct:product];
                [rowDatas addObject:cellModel];
            }
            // header info
            PZShopCarHeaderViewModel *headerModel = [[PZShopCarHeaderViewModel alloc] initWithShopCarData:data];
            
            PZShopCarCellInfosModel *infoModel = [PZShopCarCellInfosModel new];
            infoModel.cellViewModels = [rowDatas copy];
            infoModel.headerViewModel =headerModel;
            [tmpArray addObject:infoModel];
        }
        // expired Info
        if (model.expiredData.count != 0) {
            self.sectionTypeDictionary[@(self.sectionTypeDictionary.count)] = @(PZShopCarSectionInfoTypeInvalidType);
            NSMutableArray *expiredArray = [@[] mutableCopy];
            for (PZShopCarProduct *expiredProduct in model.expiredData) {
                PZShopCarInvalidCellModel *invalidModel = [[PZShopCarInvalidCellModel alloc] initWithModel:expiredProduct];
                [expiredArray addObject:invalidModel];
            }
            PZShopCarCellInfosModel *infoModel = [PZShopCarCellInfosModel new];
            infoModel.cellViewModels = [expiredArray copy];
            [tmpArray addObject:infoModel];
        }
        
        self.items = [tmpArray copy];
        DLog(@"%@-%@",model,recommendModel);
    }];
    
    [self.fetchMoreDataCommand.executionSignals.switchToLatest subscribeNext:^(PZShopCarRecommendModel * model) {
        @strongify(self);
        if (model.likelist.count == 0) {
            self.pageIndex -= 1;
            self.more = NO;
        } else {
//            for (PZShopCarRecommendProduct *product in model.likelist) {
//                
//            }
        }
    } error:^(NSError *error) {
        DLog(@"fetch More error: %@",error);
    }];
    
    return self;
}

#pragma mark - UICollectionView layout
- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section {
    switch ([self sectionTypeForSection:section]) {
        case PZShopCarSectionInfoTypeValidType:
            return UIEdgeInsetsMake(0, 0, 10, 0);
        case PZShopCarSectionInfoTypeInvalidType:
            return UIEdgeInsetsMake(0, 0, 0, 0);
        case PZShopCarSectionInfoTypeRecommendTipsType:
            return UIEdgeInsetsMake(10, 0, 0, 0);
        case PZShopCarSectionInfoTypeRecommendProductType: {
            return UIEdgeInsetsMake(0, 0, 10, 0);
        }
        default:
            return UIEdgeInsetsMake(0, 0, 10, 0);
    }
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch ([self sectionTypeForSection:indexPath.section]) {
        case PZShopCarSectionInfoTypeNoneType: {
            CGSize size =  CGSizeMake([UIScreen mainScreen].bounds.size.width, 200);
            return size;
        }
        case PZShopCarSectionInfoTypeValidType: {
            CGSize size =  CGSizeMake([UIScreen mainScreen].bounds.size.width, 104);
            return size;
        }
        case PZShopCarSectionInfoTypeInvalidType: {
            CGSize size =  CGSizeMake([UIScreen mainScreen].bounds.size.width, 93);
            return size;
        }
        case PZShopCarSectionInfoTypeRecommendTipsType: {
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 44);
        }
        case PZShopCarSectionInfoTypeRecommendClassType: {
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            CGSize size =  CGSizeMake((width - 6 * 1) / 2.0, ((width - 6 * 1) / 2.0)/0.7115);
            return size;
        }
        case PZShopCarSectionInfoTypeRecommendProductType: {
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            CGSize size =  CGSizeMake((width - 6 * 1) / 2.0, ((width - 6 * 1) / 2.0)/0.7115);
            return size;
        }
    }
}

- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger )section {
    switch ([self sectionTypeForSection:section]) {
        case PZShopCarSectionInfoTypeValidType:
        case PZShopCarSectionInfoTypeInvalidType: {
            return 0;
        }
        default: {
            return 5;
        }
    }
}

- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    switch ([self sectionTypeForSection:section]) {
        case PZShopCarSectionInfoTypeValidType:
        case PZShopCarSectionInfoTypeInvalidType: {
            return 0;
        }
        default: {
            return 5;
        }
    }
}

- (CGSize)referenceSizeForHeaderInSection:(NSInteger)section {
    switch ([self sectionTypeForSection:section]) {
        case PZShopCarSectionInfoTypeNoneType:
        case PZShopCarSectionInfoTypeRecommendTipsType: {
            return CGSizeZero;
        }
        case PZShopCarSectionInfoTypeInvalidType: {
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 10);
        }
        default: {
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 44);
        }
    }
}

- (CGSize)referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 0);
}

- (PZShopCarSectionInfoType)sectionTypeForSection:(NSInteger)section {
    return self.sectionTypeDictionary[@(section)].integerValue;
}

@end
