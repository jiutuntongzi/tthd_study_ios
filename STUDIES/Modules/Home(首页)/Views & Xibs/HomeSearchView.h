//
//  HomeSearchView.h
//  STUDIES
//
//  Created by happyi on 2019/3/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeSearchView : UIView

/** 提示文本 */
@property(nonatomic, strong) QMUILabel *searchLabel;
/** 点击搜索栏回调 */
@property(nonatomic, copy) void(^tapSearch)(void);

@end

NS_ASSUME_NONNULL_END
