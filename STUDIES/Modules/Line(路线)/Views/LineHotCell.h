//
//  LineHotCell.h
//  STUDIES
//
//  Created by happyi on 2019/5/16.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineThemeModel.h"
#import "LineThemeItemModel.h"

@interface LineHotCell : UITableViewCell
{
    UIImageView *_topImageView;
    UIView *_containerView;
}
/** 选择线路的block */
@property (nonatomic, copy) void(^selectedLineBlock)(NSString *lineId, NSString *tutorId);
/** 选择目的地的block */
@property (nonatomic, copy) void(^selectedDestinationBlock)(NSString *dId);
/** 数据模型 */
@property (nonatomic, strong) LineThemeModel *model;
@end

