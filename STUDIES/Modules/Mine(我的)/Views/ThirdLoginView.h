//
//  ThirdLoginView.h
//  STUDIES
//
//  Created by happyi on 2019/4/10.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThirdLoginView : UIView

/** 微信登录 */
@property(nonatomic, copy)void(^wechatLoginBlock)(void);
/** 微博登录 */
@property(nonatomic, copy)void(^weiboLoginBlock)(void);
/** QQ登录 */
@property(nonatomic, copy)void(^qqLoginBlock)(void);

@end

NS_ASSUME_NONNULL_END
