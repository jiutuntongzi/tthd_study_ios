//
//  TeacherFansOrFollowsCell.h
//  STUDIES
//
//  Created by happyi on 2019/5/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherFansOrFollowsModel.h"

@interface TeacherFansOrFollowsCell : UITableViewCell
{
    UIImageView *_avatarImageView;
    QMUILabel *_nameLabel;
    UIImageView *_tagImageView;
    QMUILabel *_fansLabel;
    QMUILabel *_desLabel;
    QMUIButton *_followButton;
}

/** 数据模型 */
@property (nonatomic, strong) TeacherFansOrFollowsModel *model;
/** 关注操作 */
@property (nonatomic, copy) void(^followBlock)(TeacherFansOrFollowsModel *model);
@end

