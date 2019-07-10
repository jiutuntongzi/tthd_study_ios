//
//  LineDetailTopCell.h
//  STUDIES
//
//  Created by happyi on 2019/5/27.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImagePlayerView.h>
#import "LineDetailModel.h"
#import "HCSStarRatingView.h"

@interface LineDetailTopCell : UITableViewCell<ImagePlayerViewDelegate>
{
    ImagePlayerView *_imagePlayerView;
    QMUILabel *_titleLabel;
}

/** 点击图片的回调 */
@property(nonatomic, copy) void(^imagePlayerBlock)(void);
/** 路线详情的model */
@property(nonatomic, strong) LineDetailModel *model;

@end

