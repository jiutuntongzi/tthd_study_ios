//
//  DimmingView.m
//  STUDIES
//
//  Created by happyi on 2019/5/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DimmingView.h"

@implementation DimmingView

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        return nil;
    }
    return hitView;
}

@end
