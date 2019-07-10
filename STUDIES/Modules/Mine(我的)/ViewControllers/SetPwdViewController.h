//
//  SetPwdViewController.h
//  STUDIES
//
//  Created by happyi on 2019/4/11.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"


@interface SetPwdViewController : BaseViewController

/** 验证码 */
@property(nonatomic, strong) NSString *authCode;
/** 手机号码 */
@property(nonatomic, strong) NSString *phoneNumber;

@end

