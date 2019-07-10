//
//  DynamicReplyViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"


@interface DynamicReplyViewController : BaseViewController

@property (nonatomic, strong) NSString *dynamicId;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, copy) void(^submitSuccessBlock)(void);

@end

