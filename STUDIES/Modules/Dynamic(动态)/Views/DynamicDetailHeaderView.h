//
//  DynamicDetailHeaderView.h
//  STUDIES
//
//  Created by happyi on 2019/5/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicListModel.h"


@interface DynamicDetailHeaderView : UIView
{
    UIImageView *_avatarImageView;      //头像
    QMUILabel *_nameLabel;              //名称
    QMUILabel *_timeLabel;              //时间
    QMUIButton *_tagButton;             //用户标签
    YYLabel *_contentLabel;             //内容
    UIView *_container;                 //内容视图
    QMUIButton *_noteButton;            //游记内容
    UIImageView *_noteImageView;        //游记图片
    QMUILabel *_noteTitle;              //游记标题
    QMUILabel *_noteContentLabel;       //游记内容
    UIImageView *_icon;                 //位置icon
    QMUIButton *_location;              //位置按钮
    QMUIButton *_followButton;          //关注按钮
    UIImageView *_videoImageView;       //视频封面
}

/** 数据 */
@property (nonatomic, strong) DynamicListModel *dynamicModel;
/** 关注按钮点击block */
@property (nonatomic, copy) void(^followBlock)(QMUIButton *button, DynamicListModel *model);
/** 点击内容的block */
@property (nonatomic, copy) void(^tapContent)(NSDictionary *userInfo, NSString *content);
/** 点击游记内容的block */
@property (nonatomic, copy) void(^noteBlock)(NSString *noteId);
/** 播放视频的block */
@property (nonatomic, copy) void(^playVideoBlock)(NSString *videoUrl);

@end

