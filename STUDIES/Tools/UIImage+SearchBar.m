//
//  UIImage+SearchBar.m
//  STUDIES
//
//  Created by happyi on 2019/5/6.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "UIImage+SearchBar.h"

@implementation UIImage (SearchBar)

/** 返回一个传入颜色值的iamge对象 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
