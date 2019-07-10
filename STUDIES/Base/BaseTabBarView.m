//
//  BaseTabBarView.m
//  STUDIES
//
//  Created by happyi on 2019/3/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseTabBarView.h"

@implementation BaseTabBarView

#pragma mark - 初始化tabbar按钮
-(void)addButtonWithTitle:(NSString *)title normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage
{
    QMUIButton *button = [[QMUIButton alloc] init];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColorGray forState:UIControlStateNormal];
    [button setTitleColor:UIColorBlack forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    button.imagePosition = QMUIButtonImagePositionTop;
    button.spacingBetweenImageAndTitle = 5;
    button.titleLabel.font = UIFontMake(14);
    [self addSubview:button];
}

#pragma mark - 布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    NSUInteger count = self.subviews.count;
    for (int i = 0; i < count; i ++) {
        QMUIButton *button = self.subviews[i];
        button.tag = i;
        button.frame = CGRectMake(i * self.width / count, 0, self.width / count, BaseTabBarButtonHeight);
        
        if (i == 0) {
            [self clickBtn:button];
        }
    }
    
    self.layer.borderColor = UIColorGray.CGColor;
    self.layer.borderWidth = 0.5;
}

#pragma mark - 按钮点击事件
-(void)clickBtn:(QMUIButton *)button
{
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    
    if ([self.delegate respondsToSelector:@selector(tabBarView:selectedFromIndex:toIndex:)]) {
        [self.delegate tabBarView:self selectedFromIndex:self.selectedBtn.tag toIndex:button.tag];
    }
}

@end
