//
//  MineButtonsView.h
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineButtonsView : UIView

/** 选择收藏夹的block */
@property (nonatomic, copy) void(^selectCollectBlock)(void);
/** 选择我的足记的block */
@property (nonatomic, copy) void(^selectTrackBlock)(void);
/** 选择话题的block */
@property (nonatomic, copy) void(^selectTopicBlock)(void);

@end

NS_ASSUME_NONNULL_END
