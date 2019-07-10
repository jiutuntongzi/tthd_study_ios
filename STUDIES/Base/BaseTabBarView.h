//
//  BaseTabBarView.h
//  STUDIES
//
//  Created by happyi on 2019/3/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseTabBarView;

@protocol BaseTabBarViewDelegate <NSObject>

/**
 点击tabbarButton的代理

 @param tabBarView 自定义tabbar
 @param selectedFromIndex 点击前
 @param toIndex 点击后
 */
-(void)tabBarView:(BaseTabBarView *)tabBarView selectedFromIndex:(NSInteger)selectedFromIndex toIndex:(NSInteger)toIndex;

@end

@interface BaseTabBarView : UIView

/** 代理 */
@property(nonatomic, weak) id<BaseTabBarViewDelegate>delegate;
/** 之前选中的按钮 */
@property(nonatomic, strong) QMUIButton *selectedBtn;

/**
 创建button

 @param title 标题
 @param normalImage 图片
 @param selectedImage 选中时的图片
 */
-(void)addButtonWithTitle:(NSString *)title normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage;


/**
 按钮点击

 @param button nil
 */
-(void)clickBtn:(QMUIButton *)button;

@end
