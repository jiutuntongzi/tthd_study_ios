//
//  LineDetailTeacherCell.h
//  STUDIES
//
//  Created by happyi on 2019/5/27.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineDetailModel.h"
#import "HCSStarRatingView.h"

@interface LineDetailTeacherCell : UITableViewCell
{
    UIImageView *_avatarImageView;
    QMUILabel *_nameLabel;
    UIImageView *_femaleImageView;
    HCSStarRatingView *_starView;
    QMUILabel *_desLabel;
}

/** 路线详情的model */
@property(nonatomic, strong) LineDetailModel *model;

@end

