//
//  HomeInteractCell.h
//  STUDIES
//
//  Created by happyi on 2019/3/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImagePlayerView.h>
#import "HomeCallModel.h"

@interface HomeInteractCell : UITableViewCell<ImagePlayerViewDelegate>
/** 图片轮播 */
@property (nonatomic, strong, readonly) ImagePlayerView *imagePlayerView;
/** 选择打call的block */
@property (nonatomic, copy) void(^selectedInteractBlock)(HomeCallModel *model);
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

