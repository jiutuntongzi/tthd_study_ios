//
//  TeacherEvaluateCell.h
//  STUDIES
//
//  Created by happyi on 2019/3/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherEvaluateModel.h"
#import <HCSStarRatingView.h>

@interface TeacherEvaluateCell : UITableViewCell
{
    UIImageView *_avatarImageView;
    HCSStarRatingView *_starView;
    QMUILabel *_contenLabel;
    UIView *_containerView;
    QMUILabel *_nameLabel;
    QMUILabel *_timeLabel;
}
/** 数据模型 */
@property (nonatomic, strong) TeacherEvaluateModel *model;
/** 选择图片的block */
@property (nonatomic, copy) void(^tapImageBlock)(NSArray *imageUrls, NSInteger currentIndex);
@end

