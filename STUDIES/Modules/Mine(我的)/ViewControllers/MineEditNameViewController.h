//
//  MineEditNameViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"

@interface MineEditNameViewController : BaseViewController

/** 修改成功的回调 */
@property (nonatomic, copy) void(^editNicknameSuccessBlock)(void);

@end

