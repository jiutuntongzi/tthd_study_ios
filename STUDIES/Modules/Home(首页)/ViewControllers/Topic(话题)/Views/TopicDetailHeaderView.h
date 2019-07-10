//
//  TopicHeaderView.h
//  STUDIES
//
//  Created by happyi on 2019/4/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicListModel.h"
#import "TopicDetailModel.h"

@interface TopicDetailHeaderView : UIView
{
    UIImageView *_coverImageView;
    QMUILabel *_titleLabel;
    UIImageView *_tagImageView;
    QMUILabel *_nameLabel;
    QMUILabel *_discussLabel;
    QMUILabel *_readLabel;
    QMUIButton *_followButton;
}
@property (nonatomic, strong) TopicListModel *model;

@property (nonatomic, strong) TopicDetailModel *detailModel;

@property (nonatomic, copy) void(^followTopicBlock)(TopicDetailModel *model);

@end

