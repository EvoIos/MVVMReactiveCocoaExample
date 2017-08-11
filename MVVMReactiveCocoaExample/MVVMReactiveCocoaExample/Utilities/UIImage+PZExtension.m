//
//  UIImage+PZExtension.m
//  MVVMReactiveCocoaExample
//
//  Created by z on 2017/8/11.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//

#import "UIImage+PZExtension.h"

@implementation UIImage (PZExtension)
+ (UIImage*)pz_imageWithColor:(UIColor*)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
