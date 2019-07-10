//
//  BaseViewController.h
//  STUDIES
//
//  Created by happyi on 2019/3/11.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/** 状态栏 */
@property(nonatomic, strong) UIView *statusView;
/** 导航栏 */
@property(nonatomic, strong) UIView *navView;
/** 标题 */
@property(nonatomic, strong) QMUILabel *titleLabel;
/** 左边按钮 */
@property(nonatomic, strong) QMUIButton *leftButton;
/** 右边按钮 */
@property(nonatomic, strong) QMUIButton *rightButton;



@end

