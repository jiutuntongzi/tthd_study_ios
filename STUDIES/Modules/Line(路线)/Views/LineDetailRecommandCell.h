//
//  LineDetailRecommandCell.h
//  STUDIES
//
//  Created by happyi on 2019/5/27.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineThemeItemModel.h"
@interface LineDetailRecommandCell : UITableViewCell
{
    UIView *_containerView;
}

/** 数据模型 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 选择线路的block */
@property (nonatomic, copy) void(^selectedLineBlock)(NSString *lineId, NSString *tutorId);

@end

