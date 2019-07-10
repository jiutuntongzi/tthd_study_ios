//
//  DynamicContentCell.h
//  STUDIES
//
//  Created by happyi on 2019/5/10.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicListModel.h"
#import <YYKit.h>
@interface DynamicContentCell : UITableViewCell
{
    UIImageView *_avatarImageView;      //头像
    QMUILabel *_nameLabel;              //姓名
    QMUILabel *_timeLabel;              //时间
    QMUIButton *_tagButton;             //标签
    YYLabel *_contentLabel;             //内容
    UIView *_container;                 //图片集视图
    QMUIButton *_noteButton;            //游记
    UIImageView *_noteImageView;        //游记图片
    QMUILabel *_noteTitle;              //游记标题
    QMUILabel *_noteContentLabel;       //游记内容
    QMUIButton *_commentsButton;        //评论按钮
    QMUIButton *_praiseButton;          //点赞按钮
    UIImageView *_icon;                 //位置icon
    QMUIButton *_location;              //位置
    QMUIButton *_followButton;          //关注按钮
    UIImageView *_videoImageView;       //视频封面
}
/** 数据 */
@property (nonatomic, strong) DynamicListModel *model;
/** 关注按钮 */
@property (nonatomic, strong) QMUIButton *followButton;
/** 点击关注的block */
@property (nonatomic, copy) void(^followBlock)(QMUIButton *button, DynamicListModel *model);
/** 点击内容的block */
@property (nonatomic, copy) void(^tapContent)(NSDictionary *userInfo, NSString *content);
/** 点击游记内容的block */
@property (nonatomic, copy) void(^noteBlock)(NSString *noteId);
/** 播放视频的block */
@property (nonatomic, copy) void(^playVideoBlock)(NSString *videoUrl);

/** 选择图片的block */
@property (nonatomic, copy) void(^tapImageBlock)(NSArray *imageUrls, NSInteger currentIndex);

@end

