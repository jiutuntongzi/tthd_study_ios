//
//  DynamicDetailCommentCell.h
//  STUDIES
//
//  Created by happyi on 2019/5/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "DynamicCommentModel.h"
@interface DynamicDetailCommentCell : UITableViewCell
{
    BOOL _isHaveImage;                      //是否有图片
    BOOL _isHaveReply;                      //是否有回复
    UIImageView *_avatarImageView;          //头像
    QMUILabel *_nameLabel;                  //名称
    QMUILabel *_timeLabel;                  //时间
    YYLabel *_contentLabel;               //内容
    UIImageView *_commentImageView;         //评论图片
    QMUIButton *_replyButton;               //回复按钮
    QMUIButton *_praiseButton;              //点赞按钮
    QMUIButton *_commentButton;             //评论按钮
    QMUIButton *_topButton;                 //按钮1
    QMUIButton *_downButton;                //按钮2
    UIView *_line;                          //下划线
}

@property (nonatomic, strong) DynamicCommentModel *model;
/** 点击回复的block */
@property (nonatomic, copy) void(^replyBlock)(DynamicCommentModel *model);
/** 点赞的block */
@property (nonatomic, copy) void(^praiseBlock)(DynamicCommentModel *model);
/** 点击菜单的block */
@property (nonatomic, copy) void(^menuBlock)(DynamicCommentModel *model, QMUIButton *button);
@property (nonatomic, copy) void(^commentBlock)(DynamicCommentModel *model);
/** 点击内容的block */
@property (nonatomic, copy) void(^tapContent)(NSDictionary *userInfo, NSString *content);
/** 选择图片的block */
@property (nonatomic, copy) void(^tapImageBlock)(NSArray *imageUrls, NSInteger currentIndex);

@end

