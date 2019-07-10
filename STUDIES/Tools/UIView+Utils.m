//
//  UIView+Utils.m
//  STUDIES
//
//  Created by happyi on 2019/5/6.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

-(UIView *)subViewOfClassName:(NSString *)className
{
    for (UIView *subView in self.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className]) {
            return subView;
        }
        
        UIView *result = [subView subViewOfClassName:className];
        if (result) {
            return result;
        }
    }
    
    return [UIView new];
}

@end
