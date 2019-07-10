//
//  StudyContentCell.h
//  STUDIES
//
//  Created by happyi on 2019/5/8.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineThemeModel.h"

@interface StudyContentCell : UICollectionViewCell
{
    UIImageView *_coverImageView;
}
/** 数据源 */
@property (nonatomic, strong) LineThemeModel *model;

@end

