//
//  MineSetViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"

@interface MineSetViewController : BaseViewController

/** 退出登录的block */
@property (nonatomic, copy) void(^logoutBlock)(void);

@end
