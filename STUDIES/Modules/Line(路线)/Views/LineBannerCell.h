//
//  LineBannerCell.h
//  STUDIES
//
//  Created by happyi on 2019/5/8.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImagePlayerView.h>
#import "HomeSearchView.h"

@interface LineBannerCell : UITableViewCell<ImagePlayerViewDelegate>

/** 图片轮播控件 */
@property (nonatomic, strong, readonly) ImagePlayerView *imagePlayerView;
/** 搜索栏 */
@property (nonatomic, strong) HomeSearchView *searchView;
/** 搜索的block */
@property (nonatomic, copy) void(^touchSearchBlock)(void);
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

