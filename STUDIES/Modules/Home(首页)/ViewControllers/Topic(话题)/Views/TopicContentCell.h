//
//  TopicContentCell.h
//  STUDIES
//
//  Created by happyi on 2019/4/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicListModel.h"

@interface TopicContentCell : UITableViewCell
{
    QMUILabel *_titleLabel;
    QMUILabel *_discussLabel;
    QMUILabel *_contentLabel;
    UIImageView *_avatarImageView;
    QMUILabel *_nameLabel;
    QMUILabel *_timeLabel;
    UIImageView *_coverIamgeView;
}
/** 数据模型 */
@property (nonatomic, strong) TopicListModel *model;

@end

