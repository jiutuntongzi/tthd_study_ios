//
//  NoteDetailImageCell.h
//  STUDIES
//
//  Created by happyi on 2019/4/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteDetailModel.h"

@interface NoteDetailContentCell : UITableViewCell
{
    UIImageView *_topImageView;
    QMUILabel *_titleLabel;
    UIImageView *_avatarImageView;
    QMUILabel *_nameLabel;
    QMUILabel *_timeLabel;
    QMUIButton *_tagButton;
    QMUIButton *_followButton;
    QMUIButton *_commentButton;
    QMUIButton *_praiseButton;
    QMUIButton *_collectButton;
    QMUILabel *_contentLabel;
}
/** 关注的回掉 */
@property(nonatomic, copy) void(^followBlock)(NSString *title);
/** 数据模型 */
@property(nonatomic, strong) NoteDetailModel *model;
/** 关注按钮 */
@property(nonatomic, strong) QMUIButton *followButton;
@end

