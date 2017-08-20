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

@interface PZShopCarViewModel : NSObject

/// 是否含有更多数据
@property (nonatomic, assign, readonly, getter=isMore) BOOL more;

@property (nonatomic, strong, readonly) NSArray <PZShopCarCellInfosModel*>*items;

@property (nonatomic, strong, readonly) RACCommand *fetchDataCommand;
@property (nonatomic, strong, readonly) RACCommand *fetchMoreDataCommand;

// MARK: - info for collectionView
- (id)cellItemViewModelForSection:(NSInteger)section row:(NSInteger)row;
- (id)headerItemViewModelForSection:(NSInteger)section;
- (id)footerItemViewModelForSection:(NSInteger)section;
- (NSArray *)getInvlidListShopIds;

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
