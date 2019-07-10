//
//  NoteSearchCell.h
//  STUDIES
//
//  Created by happyi on 2019/4/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteSearchModel.h"

@interface NoteSearchCell : UITableViewCell
/** 数据模型 */
@property (nonatomic, strong) NoteSearchModel *model;
/** 图片 */
@property (nonatomic, strong) UIImageView *noteImageView;
/** 精选标签 */
@property (nonatomic, strong) QMUILabel *siftLabel;
/** 标题 */
@property (nonatomic, strong) QMUILabel *titleLabel;
/** 头像 */
@property (nonatomic, strong) UIImageView *avatarImageView;
/** 姓名 */
@property (nonatomic, strong) QMUILabel *nameLabel;
/** 时间 */
@property (nonatomic, strong) QMUILabel *timeLabel;
/** 点赞按钮 */
@property (nonatomic, strong) QMUIButton *praiseButton;
/** 收藏按钮 */
@property (nonatomic, strong) QMUIButton *collectButton;
@end
