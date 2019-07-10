//
//  HomeLineItemCell.h
//  STUDIES
//
//  Created by happyi on 2019/3/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePathModel.h"

@interface HomeLineItemCell : UICollectionViewCell
{
    UIImageView *_avatarImageView;
    UIImageView *_coverImageView;
    QMUILabel *_titleLabel;
}
/** 数据 */
@property (nonatomic, strong) HomePathModel *model;

@end

