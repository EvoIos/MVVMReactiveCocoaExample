//
//  NSString+MoneyStyle.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/7/12.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "NSString+MoneyStyle.h"

@implementation NSString (MoneyStyle)

+ (NSMutableAttributedString *)differentFontWithMoney:(CGFloat)money moneyFont:(UIFont *)moneyFont integerFont:(UIFont *)integerFont decimalPointFont:(UIFont *)decimalPointFont{
    NSString *settingStr  = [NSString stringWithFormat:@"%.2f",money];
    if (moneyFont) {
        settingStr = [NSString stringWithFormat:@"￥%@",settingStr];
    }
    NSDictionary *attribs = @{ NSFontAttributeName: integerFont };
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:settingStr
                                           attributes:attribs];
    // bigTextRange text attributes
    NSRange dollorRange = [settingStr rangeOfString:@"￥"];
    NSRange dotRange = [settingStr rangeOfString:@"."];
    
    NSInteger startIdx = 0;
    if (dollorRange.location !=  NSNotFound && moneyFont) {
        startIdx = 1;
        [attributedText setAttributes:@{NSFontAttributeName:moneyFont}
                                range:dollorRange];
    }
    NSRange bigTextRange = NSMakeRange(startIdx, dotRange.location);
    [attributedText setAttributes:@{NSFontAttributeName:integerFont}
                            range:bigTextRange];
    NSRange smallTextRange = NSMakeRange(dotRange.location+1, 2);
    [attributedText setAttributes:@{NSFontAttributeName:decimalPointFont}
                            range:smallTextRange];
    return attributedText;
}
@end
