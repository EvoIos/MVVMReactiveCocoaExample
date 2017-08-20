//
//  PZShopCarStateEnum.h
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#ifndef PZShopCarStateEnum_h
#define PZShopCarStateEnum_h

/// 购物车编辑状态
typedef NS_ENUM(NSInteger,PZShopCarEditStateType) {
    PZShopCarEditStateTypeNormal,    /**< 正常状态*/
    PZShopCarEditStateTypeEditing,   /**< 编辑自身*/
    PZShopCarEditStateTypeEditALl    /**< 编辑所有*/
};

/// 购物车 section 分段信息
typedef NS_ENUM(NSInteger,PZShopCarSectionInfoType) {
    PZShopCarSectionInfoTypeNoneType = 0,     /**< 无信息*/
    PZShopCarSectionInfoTypeValidType,        /**< 购物车商品*/
    PZShopCarSectionInfoTypeInvalidType,      /**< 失效商品*/
    PZShopCarSectionInfoTypeRecommendTipsType,    /**< 为你推荐*/
    PZShopCarSectionInfoTypeRecommendClassType,   /**< 推荐分类*/
    PZShopCarSectionInfoTypeRecommendProductType  /**< 推荐商品*/
};

#endif /* PZShopCarStateEnum_h */
