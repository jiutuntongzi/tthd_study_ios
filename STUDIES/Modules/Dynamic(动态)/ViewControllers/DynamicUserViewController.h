//
//  DynamicUserViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/10.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "QMUIModalPresentationViewController.h"
#import "UserModel.h"

@interface DynamicUserViewController : QMUIModalPresentationViewController

/** 选择用户 */
@property(nonatomic, copy) void(^selectUserBlock)(UserModel *model, NSMutableArray <UserModel *> *userArray);

@end
