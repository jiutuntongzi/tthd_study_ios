//
//  LineDetailHeaderView.h
//  STUDIES
//
//  Created by happyi on 2019/5/9.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImagePlayerView.h>
#import "LineDetailModel.h"
#import "HCSStarRatingView.h"
@interface LineDetailHeaderView : UIView<ImagePlayerViewDelegate>
{
    ImagePlayerView *_imagePlayerView;
    QMUILabel *_titleLabel;
    UIImageView *_avatarImageView;
    QMUILabel *_nameLabel;
    UIImageView *_femaleImageView;
    HCSStarRatingView *_starView;
    QMUILabel *_desLabel;
}
/** 返回的回调 */
@property(nonatomic, copy) void(^backBlock)(void);
/** 分享的回调 */
@property(nonatomic, copy) void(^shareBlock)(void);
/** 点击图片的回调 */
@property(nonatomic, copy) void(^imagePlayerBlock)(void);
/** 路线详情的model */
@property(nonatomic, strong) LineDetailModel *model;
@end

