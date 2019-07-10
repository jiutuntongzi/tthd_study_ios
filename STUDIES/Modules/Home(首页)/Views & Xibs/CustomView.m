//
//  CustomView.m
//  STUDIES
//
//  Created by happyi on 2019/3/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.fillColor = self.backgroundColor.CGColor;
    borderLayer.path = maskPath.CGPath;
    borderLayer.lineWidth = 0;
    borderLayer.strokeColor = UIColorClear.CGColor;
    borderLayer.frame = self.bounds;
    borderLayer.cornerRadius = 10;
    [self.layer addSublayer:borderLayer];
    
    UIBezierPath *borderPath = [UIBezierPath bezierPath];
    [borderPath moveToPoint:(CGPoint){0,0}];
    [borderPath addLineToPoint:(CGPoint){30, 0}];
    [borderPath addLineToPoint:(CGPoint){40, - 10}];
    [borderPath addLineToPoint:(CGPoint){50, 0}];
    [borderPath addLineToPoint:(CGPoint){self.width, 0}];
    borderLayer.path = borderPath.CGPath;
}

@end
