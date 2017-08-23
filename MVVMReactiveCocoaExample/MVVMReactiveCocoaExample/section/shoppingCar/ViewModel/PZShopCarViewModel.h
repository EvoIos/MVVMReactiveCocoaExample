//
//  PZShopCarViewModel.h
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/19.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZShopCarValidCellModel.h"
#import "PZShopCarStateEnum.h"
#import "PZShopCarCellInfosModel.h"
#import "PZShopCarSettlementViewModel.h"

@interface PZShopCarViewModel : NSObject
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign, readonly, getter=isEdited)    BOOL edited;
@property (nonatomic, assign, readonly, getter=isMarked)    BOOL marked;
@property (nonatomic, assign, readonly, getter=isMore)      BOOL more;
@property (nonatomic, strong, readonly) NSArray <PZShopCarCellInfosModel*>*items;
@property (nonatomic, strong) PZShopCarSettlementViewModel *settlementViewModel;

@property (nonatomic, strong, readonly) RACCommand *fetchDataCommand;
@property (nonatomic, strong, readonly) RACCommand *fetchMoreDataCommand;
/** @brief 选中单个商品，section商品，全部商品
 *  input: 选中全部 UIButton，其他 @{ @"type":indexPath/section,@"indexPath":NSIndexPath,@"section":section}
 */
@property (nonatomic, strong, readonly) RACCommand *markCommand;

// MARK: - info for collectionView
- (id)cellItemViewModelForSection:(NSInteger)section row:(NSInteger)row;
- (id)headerItemViewModelForSection:(NSInteger)section;
- (id)footerItemViewModelForSection:(NSInteger)section;

// MARK: - layout
- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section;
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger )section;
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (CGSize)referenceSizeForHeaderInSection:(NSInteger)section;
- (CGSize)referenceSizeForFooterInSection:(NSInteger)section;
// MARK: - helper
- (PZShopCarSectionInfoType)sectionTypeForSection:(NSInteger)section;

@end
