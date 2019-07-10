//
//  HomeTravelCell.h
//  STUDIES
//
//  Created by happyi on 2019/3/16.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteListModel.h"

@interface HomeTravelCell : UITableViewCell
{
    UIImageView *_avatarImageView;          //头像
    QMUILabel *_nameLabel;                  //名称
    UIImageView *_siftImageView;            //精选标签
    QMUILabel *_timeLabel;                  //时间
    QMUILabel *_contentLabel;               //内容
     
    UIView *_container;                     //图片
    QMUIButton *_viewButton;                //点击数按钮
    QMUIButton *_commentButton;             //评论数按钮
}

/** 数据模型 */
@property (nonatomic, strong) NoteListModel *model;
/** 选择游记的block */
@property (nonatomic, strong) void(^selectNoteBlock)(NoteListModel *model);
/** 选择图片的block */
@property (nonatomic, copy) void(^tapImageBlock)(NSArray *imageUrls, NSInteger currentIndex);
@end


