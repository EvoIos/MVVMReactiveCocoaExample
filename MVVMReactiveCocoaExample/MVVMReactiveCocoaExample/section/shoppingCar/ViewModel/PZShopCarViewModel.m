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
#import "PZShopCarRecommendCellModel.h"

@interface PZShopCarViewModel()

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign, readwrite, getter=isMarked) BOOL marked;
@property (nonatomic, assign, readwrite, getter=isEdited) BOOL edited;
@property (nonatomic, assign, readwrite, getter=isMore) BOOL more;

@property (nonatomic, strong, readwrite) NSArray * items;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSNumber *> *sectionTypeDictionary;
@property (nonatomic, strong) NSDictionary <NSIndexPath *, NSArray<PZShopCarValidCellModel *> *> *markedDicionary;
@property (nonatomic, strong) NSArray <NSArray<PZShopCarValidCellModel *> *> *markedArray;

@property (nonatomic, strong) RACSignal *fetchListSignal;
@property (nonatomic, strong) RACSignal *fetchRecommendListSignal;
@property (nonatomic, strong, readwrite) RACCommand *fetchDataCommand;
@property (nonatomic, strong, readwrite) RACCommand *fetchMoreDataCommand;
@property (nonatomic, strong, readwrite) RACCommand *markCommand;
@property (nonatomic, strong, readwrite) RACCommand *editCommand;
@property (nonatomic, strong, readwrite) RACCommand *deleteCommand;

@end

@implementation PZShopCarViewModel

- (void)initializeData {
    self.pageIndex = 0;
    
    self.price = 0.0;
    self.edited = NO;
    self.marked = NO;
    self.more = YES;
    
    self.sectionTypeDictionary = [@{} mutableCopy];
    self.markedDicionary = @{};
    self.markedArray = @[];
    self.items = @[];
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    @weakify(self);
    // request data
    self.fetchDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self initializeData];
        return [self.fetchListSignal combineLatestWith:self.fetchRecommendListSignal] ;
    }];
    self.fetchMoreDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.pageIndex += 1;
        return self.fetchRecommendListSignal;
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
            self.markedArray = [tmpArray copy];
            
        }
        // expired Info
//        if (model.expiredData.count != 0) {
//            self.sectionTypeDictionary[@(self.sectionTypeDictionary.count)] = @(PZShopCarSectionInfoTypeInvalidType);
//            NSMutableArray *expiredArray = [@[] mutableCopy];
//            for (PZShopCarProduct *expiredProduct in model.expiredData) {
//                PZShopCarInvalidCellModel *invalidModel = [[PZShopCarInvalidCellModel alloc] initWithModel:expiredProduct];
//                [expiredArray addObject:invalidModel];
//            }
//            PZShopCarCellInfosModel *infoModel = [PZShopCarCellInfosModel new];
//            infoModel.cellViewModels = [expiredArray copy];
//            [tmpArray addObject:infoModel];
//        }
//        // recommend list
//            for (PZShopCarRecommendData * recommendData in recommendModel.recommendlist) {
//                self.sectionTypeDictionary[@(self.sectionTypeDictionary.count)] = @(PZShopCarSectionInfoTypeRecommendClassType);
//                
//                NSMutableArray *recommendList = [@[] mutableCopy];
//                for (PZShopCarRecommendProduct *recommendProduct in recommendData.products) {
//                    PZShopCarRecommendCellModel *cellModel = [[PZShopCarRecommendCellModel alloc] initWithProduct:recommendProduct];
//                    [recommendList addObject:cellModel];
//                }
//                
//                PZShopCarHeaderViewModel *headerModel = [[PZShopCarHeaderViewModel alloc] initWithShopCarRecommendData:recommendData];
//                
//                PZShopCarCellInfosModel *infoModel = [PZShopCarCellInfosModel new];
//                infoModel.cellViewModels = [recommendList copy];
//                infoModel.headerViewModel = headerModel;
//                [tmpArray addObject:infoModel];
//            }
//        // like list
//        if (recommendModel.likelist.count != 0) {
//            self.sectionTypeDictionary[@(self.sectionTypeDictionary.count)] = @(PZShopCarSectionInfoTypeRecommendProductType);
//            NSMutableArray *likeArray = [@[] mutableCopy];
//            for (PZShopCarRecommendProduct *product in recommendModel.likelist) {
//                PZShopCarRecommendCellModel *cellModel = [[PZShopCarRecommendCellModel alloc] initWithProduct:product];
//                [likeArray addObject:cellModel];
//            }
//            PZShopCarHeaderViewModel *headerModel = [[PZShopCarHeaderViewModel alloc] initWithTitle:@"猜你喜欢"];
//            
//            PZShopCarCellInfosModel *infoModel = [PZShopCarCellInfosModel new];
//            infoModel.cellViewModels = [likeArray copy];
//            infoModel.headerViewModel = headerModel;
//            [tmpArray addObject:infoModel];
//        }
        
        self.items = [tmpArray copy];
        
    }];
    
    [self.fetchMoreDataCommand.executionSignals.switchToLatest subscribeNext:^(PZShopCarRecommendModel * model) {
        @strongify(self);
        if (model.likelist.count == 0) {
            self.pageIndex -= 1;
            self.more = NO;
        } else {
            // recommend List 不会发生变化，只有 like list 会发生变化
            PZShopCarCellInfosModel *infoModel = self.items[self.sectionTypeDictionary.count-1];
            NSMutableArray *cellModels = [infoModel.cellViewModels mutableCopy];
            for (PZShopCarRecommendProduct *product in model.likelist) {
                PZShopCarRecommendCellModel *cellModel = [[PZShopCarRecommendCellModel alloc] initWithProduct:product];
                [cellModels addObject:cellModel];
            }
            infoModel.cellViewModels = [cellModels copy];
        }
    } error:^(NSError *error) {
        DLog(@"fetch More error: %@",error);
    }];
    
    // button event
    self.markCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *( id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            if ([input isKindOfClass:[UIButton class]]) {
                self.marked = !self.isMarked;
                [[[[[self.items rac_sequence]
                    filter:^BOOL(PZShopCarCellInfosModel *value) {
                        return value.headerViewModel.state != nil;
                    }]
                   map:^id(PZShopCarCellInfosModel * value) {
                       @strongify(self);
                       value.headerViewModel.state.marked = self.marked;
                       return value.cellViewModels;
                   }]
                  map:^id(NSArray * value) {
                      @strongify(self);
                      return [[value.rac_sequence map:^id(PZShopCarValidCellModel * value) {
                          @strongify(self);
                          value.state.marked = self.isMarked;
                          return value;
                      }] array];
                  }] array];
            } else {
                NSDictionary *dic = (NSDictionary *)input;
                NSMutableDictionary *tmpDic = [self.markedDicionary mutableCopy];
                if ([dic[@"type"] isEqualToString:@"indexPath"]) {
                    NSIndexPath *indexPath = (NSIndexPath *)dic[@"indexPath"];
                    PZShopCarValidCellModel *cellModel = self.items[indexPath.section].cellViewModels[indexPath.row];
                    cellModel.state.marked =  !cellModel.state.isMarked;
                } else if ([dic[@"type"] isEqualToString:@"section"]) {
                    NSNumber *section = (NSNumber *)dic[@"section"];
                    PZShopCarCellInfosModel *infoModel = self.items[section.integerValue];
                    BOOL isMarked = !infoModel.headerViewModel.state.isMarked;
                    infoModel.headerViewModel.state.marked = isMarked;
                    [[infoModel.cellViewModels.rac_sequence map:^id(PZShopCarValidCellModel * value) {
                        value.state.marked = isMarked;
                        return value;
                    }] array];
                }
                self.markedDicionary = [tmpDic copy];
                // update state info
                [self updateMarkedValue];
            }
            [self updatePriceAndCountValue];
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    self.editCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            if ([input isKindOfClass:[UIButton class]]) {
                self.edited = !self.isEdited;
                PZShopCarEditStateType state =
                !self.edited ?
                PZShopCarEditStateTypeNormal :
                PZShopCarEditStateTypeEditALl;
                
                [[[[[self.items rac_sequence]
                    filter:^BOOL(PZShopCarCellInfosModel *value) {
                        return value.headerViewModel.state != nil;
                    }]
                   map:^id(PZShopCarCellInfosModel * value) {
                       value.headerViewModel.state.editedState = state;
                       return value.cellViewModels;
                   }]
                  map:^id(NSArray * value) {
                      return [[value.rac_sequence map:^id(PZShopCarValidCellModel * value) {
                          value.state.editedState = state;
                          return value;
                      }] array];
                  }] array];
            } else {
                // edit section
                NSInteger section = ((NSNumber *)input).integerValue;
                PZShopCarCellInfosModel *info = self.items[section];
                PZShopCarEditStateType state =  info.headerViewModel.state.editedState;
                if (state == PZShopCarEditStateTypeEditing) {
                    // editing -> normal
                    info.headerViewModel.state.editedState = PZShopCarEditStateTypeNormal;
                    
                } else {
                    // normal -> editing
                    info.headerViewModel.state.editedState = PZShopCarEditStateTypeEditing;
                }
                
                [[info.cellViewModels.rac_sequence map:^id(PZShopCarValidCellModel* value) {
                    value.state.editedState = info.headerViewModel.state.editedState;
                    return value;
                }] array];

            }
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    self.deleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            NSIndexPath *indexPath = input;
            NSMutableArray *tmpArray = [self.items mutableCopy];
            PZShopCarCellInfosModel *info = tmpArray[indexPath.section];
            if (info.cellViewModels.count == 1) {
                [tmpArray removeObject:info];
            } else {
                NSMutableArray *tmpCellModels = [info.cellViewModels mutableCopy];
                [tmpCellModels removeObject:tmpCellModels[indexPath.row]];
                info.cellViewModels = [tmpCellModels copy];
            }
            self.items = [tmpArray copy];
            
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    
    return self;
}

/// update count/pirce value
- (void)updatePriceAndCountValue {
    NSArray *valideArray = [[[self.items rac_sequence]
                            filter:^BOOL(PZShopCarCellInfosModel *value) {
                                return value.headerViewModel.state != nil;
                            }] array];
    NSInteger count = 0;
    CGFloat price = 0.0;
    for (PZShopCarCellInfosModel *info in valideArray) {
        for (PZShopCarValidCellModel *cellModel in info.cellViewModels) {
            if  (cellModel.state.isMarked == YES) {
                count += 1;
                price += cellModel.price *cellModel.count;
            }
        }
    }
    self.price = price;
    self.count = count;
}

/// update mark state
- (void) updateMarkedValue {
    @weakify(self);
    NSArray *validArray = [[[self.sectionTypeDictionary.allValues rac_sequence]
                            filter:^BOOL(NSNumber * value) {
                                return value.integerValue == PZShopCarSectionInfoTypeValidType;
                            }] array];
    
    NSArray *filterArray = [[[[[self.items rac_sequence]
                               filter:^BOOL(PZShopCarCellInfosModel *value) {
                                   return value.headerViewModel.state != nil;
                               }]
                              map:^id(PZShopCarCellInfosModel *info) {
                                  @strongify(self);
                                  info.headerViewModel.state.marked = [self stateIsYesInArray:info.cellViewModels];
                                  return info;
                              }]
                             filter:^BOOL(PZShopCarCellInfosModel *info) {
                                 return info.headerViewModel.state.isMarked;
                             }] array];
    self.marked = validArray.count == filterArray.count;
}

/// 判断 array 里的所有 state 是否都是 YES
- (BOOL)stateIsYesInArray:(NSArray <PZShopCarValidCellModel *>*)array  {
    BOOL result = YES;
    for (PZShopCarValidCellModel *cellModel in array) {
        if  (cellModel.state.isMarked == NO) {
            result = NO;
            break;
        }
    }
    return result;
}

#pragma mark - UICollectionView layout
- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section {
    switch ([self sectionTypeForSection:section]) {
        case PZShopCarSectionInfoTypeValidType:
            return UIEdgeInsetsMake(0, 0, 0, 0);
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
    return 0;
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
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 54);
        }
    }
}

- (CGSize)referenceSizeForFooterInSection:(NSInteger)section {
    switch ([self sectionTypeForSection:section]) {
        case PZShopCarSectionInfoTypeValidType: {
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 10);
        }
        default: {
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 0);
        }
    }
}

- (PZShopCarSectionInfoType)sectionTypeForSection:(NSInteger)section {
    return self.sectionTypeDictionary[@(section)].integerValue;
}

#pragma mark - setter and getter

- (RACSignal *)fetchListSignal {
    if (!_fetchListSignal) {
        _fetchListSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
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
    }
    return _fetchListSignal;
}

- (RACSignal *)fetchRecommendListSignal {
    if (!_fetchRecommendListSignal) {
        _fetchRecommendListSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
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
    }
    return _fetchRecommendListSignal;
}

- (PZShopCarSettlementViewModel *)settlementViewModel {
    if (!_settlementViewModel) {
        _settlementViewModel = [PZShopCarSettlementViewModel new];
    }
    return _settlementViewModel;
}

@end
