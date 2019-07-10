//
//  HomeTeacherItemCell.h
//  STUDIES
//
//  Created by happyi on 2019/3/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTutorModel.h"
#import "HCSStarRatingView.h"

@interface HomeTeacherItemCell : UICollectionViewCell
{
    UIImageView *_avatarImageView;
    HCSStarRatingView *_starView;
    QMUILabel *_nameLabel;
    QMUILabel *_desLabel;
    QMUIButton *_followButton;
}

@property(nonatomic, strong) HomeTutorModel *model;

@end

