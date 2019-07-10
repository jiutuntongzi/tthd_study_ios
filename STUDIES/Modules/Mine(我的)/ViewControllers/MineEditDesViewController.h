//
//  MineEditDesViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"

@interface MineEditDesViewController : BaseViewController

/** 修改成功的回调 */
@property (nonatomic, copy) void(^editDesSuccessBlock)(void);

@end

