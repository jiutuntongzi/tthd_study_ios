//
//  HomeTeacherContentCell.h
//  STUDIES
//
//  Created by happyi on 2019/3/19.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherModel.h"
#import <HCSStarRatingView.h>

@interface HomeTeacherContentCell : UITableViewCell
{
    UIImageView *_avatarImageView;
    QMUILabel *_nameLabel;
    UIImageView *_femaleImageView;
    HCSStarRatingView *_starView;
    QMUILabel *_desLabel;
    QMUIButton *_followButton;
}

/** 数据模型 */
@property (nonatomic, strong) TeacherModel *model;
/** 关注的block */
@property (nonatomic, copy) void(^followBlock)(TeacherModel *model);
@end

