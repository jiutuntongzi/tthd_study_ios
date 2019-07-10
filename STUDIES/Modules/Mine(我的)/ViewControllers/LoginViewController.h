//
//  LoginViewController.h
//  STUDIES
//
//  Created by happyi on 2019/4/10.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

/** 登录成功的block */
@property (nonatomic, copy) void(^loginSuccessBlock)(void);
/** 注册的block */
@property (nonatomic, copy) void(^registerBlock)(void);
@end

