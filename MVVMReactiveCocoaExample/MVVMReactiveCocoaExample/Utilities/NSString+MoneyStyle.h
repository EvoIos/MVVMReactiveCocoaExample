//
//  NSString+MoneyStyle.h
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/7/12.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (MoneyStyle)

/**
 * @brief 根据需要显示金钱值，调整符号“￥”、整数部分、小数部分的字体大小。 <p> 如“￥123.45”,调整为：￥-字体（13），123-字体（15），45-字体（11）：
 * @code
 *  NSString *testStr = [NSString differentFontWithMoney:123.45
 *                                             moneyFont:[UIFont systemFontOfSize:13]
 *                                           integerFont:[UIFont systemFontOfSize:15]
 *                                      decimalPointFont:[UIFont systemFontOfSize:11]];
 *
 * @endcode
 *
 * @param  money 值，如：123.45
 * @param  moneyFont 金钱符号字体
 * @param  integerFont 整数部分字体
 * @param  decimalPointFont 小数部分字体
 *
 * @return 返回 NSMutableAttributedString
 *
 * @see someMethod
 * @see someMethodByInt:
 */
+ (NSMutableAttributedString *)differentFontWithMoney:(CGFloat)money moneyFont:(UIFont *)moneyFont integerFont:(UIFont *)integerFont decimalPointFont:(UIFont *)decimalPointFont;
@end
