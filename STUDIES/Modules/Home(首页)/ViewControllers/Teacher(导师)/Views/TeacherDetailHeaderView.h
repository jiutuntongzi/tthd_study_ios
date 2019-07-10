//
//  PagingViewTableHeaderView.h
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherDetailModel.h"
#import "HCSStarRatingView.h"

@interface TeacherDetailHeaderView : UIView
{
    UIImageView *_avatarImageView;
    QMUILabel *_nameLabel;
    HCSStarRatingView *_starView;
    UIImageView *_femaleImageView;
    QMUIButton *_followsButton;
    QMUIButton *_fansButton;
    QMUILabel *_desLabel;
}
/** 关注的响应 */
@property(nonatomic, copy)void(^followBlock)(void);
/** 粉丝的响应 */
@property(nonatomic, copy)void(^fansBlock)(void);
/** 分享的响应 */
@property(nonatomic, copy)void(^shareBlock)(void);

/** 数据模型 */
@property (nonatomic, strong) TeacherDetailModel *model;
/** tag */
@property (nonatomic, strong) QMUIButton *tagButton;
@end
