//
//  NoteDetailReplyCell.h
//  STUDIES
//
//  Created by happyi on 2019/5/23.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteDetailCommentModel.h"
#import "TFHpple.h"
@interface NoteDetailReplyCell : UITableViewCell
{
    UIImageView *_avatarImageView;          //头像
    QMUILabel *_nameLabel;                  //名称
    QMUILabel *_timeLabel;                  //时间
    YYLabel *_contentLabel;               //内容
    UIImageView *_commentImageView;         //评论图片
    QMUIButton *_praiseButton;              //点赞按钮
    QMUIButton *_topButton;                 //按钮1
    UIView *_line;                          //下划线
}
/** 数据模型 */
@property (nonatomic, strong) NoteDetailCommentModel *model;
/** 评论按钮 */
@property (nonatomic, strong) QMUIButton *commentButton;
/** 查看原文按钮 */
@property (nonatomic, strong) QMUIButton *checkButton;
/** 查看原文block */
@property (nonatomic, copy) void(^checkBlock)(void);
/** 点赞的block */
@property (nonatomic, copy) void(^praiseBlock)(NoteDetailCommentModel *model);
/** 菜单的block */
@property (nonatomic, copy) void(^menuBlock)(NoteDetailCommentModel *model, QMUIButton *button);

/** 点击内容的block */
@property (nonatomic, copy) void(^tapContent)(NSDictionary *userInfo, NSString *content);

@end
