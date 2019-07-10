//
//  HomeBannerCell.h
//  STUDIES
//
//  Created by happyi on 2019/3/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImagePlayerView.h>
#import "HomeSearchView.h"
#import "BannerModel.h"
@interface HomeBannerCell : UITableViewCell<ImagePlayerViewDelegate>

/** 图片轮播控件 */
@property(nonatomic, strong, readonly) ImagePlayerView *imagePlayerView;
/** 按钮 */
@property(nonatomic, strong, readonly) QMUIButton *menuButton;
/** 搜索栏 */
@property(nonatomic, strong, readonly) HomeSearchView *searchView;
/** 菜单按钮点击 */
@property(nonatomic, copy) void(^menuBtnClicked)(QMUIButton *button);
/** 图片集 */
@property(nonatomic, strong) NSMutableArray <BannerModel *> *modelArray;
/** 选择图片 */
@property(nonatomic, copy) void(^tapImageBlock)(NSMutableArray *imageUrls, NSInteger curIndex);
@end

