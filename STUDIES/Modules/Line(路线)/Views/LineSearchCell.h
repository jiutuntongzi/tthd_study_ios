//
//  LineSearchCell.h
//  STUDIES
//
//  Created by happyi on 2019/5/9.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineThemeItemModel.h"

@interface LineSearchCell : UITableViewCell
{
    UIImageView *_imageView;
    QMUILabel *_titleLabel;
    UIImageView *_avatarImageView;
    QMUILabel *_nameLabel;
}

/** 数据模型 */
@property (nonatomic, strong) LineThemeItemModel *model;

@end

