//
//  HomeMenuCell.h
//  STUDIES
//
//  Created by happyi on 2019/3/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeMenuCell : UITableViewCell
/** 父视图 */
@property(nonatomic, strong, readonly) UIView *containerView;
/** 按钮点击回调 */
@property(nonatomic, copy) void(^selectMenu)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
