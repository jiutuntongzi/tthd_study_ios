//
//  HomeMenuViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "QMUIModalPresentationViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeMenuViewController : QMUIModalPresentationViewController

/** 发布动态 */
@property (nonatomic, copy) void(^dynamicBlock)(void);
/** 发布游记 */
@property (nonatomic, copy) void(^noteBlock)(void);
/** 招募导师 */
@property (nonatomic, copy) void(^recruitBlock)(void);

@end

NS_ASSUME_NONNULL_END
