//
//  TopicSearchCell.h
//  STUDIES
//
//  Created by happyi on 2019/4/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicListModel.h"

@interface TopicSearchCell : UITableViewCell
{
    UIImageView *_imageView;
    QMUILabel *_titleLabel;
    QMUILabel *_contentLabel;
    QMUILabel *_discussLabel;
}
@property(nonatomic, strong) TopicListModel *model;

@end

