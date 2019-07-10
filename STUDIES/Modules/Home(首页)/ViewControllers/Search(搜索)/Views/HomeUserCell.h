//
//  HomeUserCell.h
//  STUDIES
//
//  Created by happyi on 2019/6/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeUserModel.h"

@interface HomeUserCell : UITableViewCell
{
    UIImageView *_avatarImageView;
    QMUILabel *_nameLabel;
    QMUILabel *_fansLabel;
    QMUILabel *_desLabel;
}

/** 数据模型 */
@property (nonatomic, strong) HomeUserModel *model;


@end

