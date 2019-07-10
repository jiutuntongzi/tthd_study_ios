//
//  DynamicCommentListViewController.h
//  STUDIES
//
//  Created by happyi on 2019/6/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"
#import "DynamicCommentModel.h"

@interface DynamicCommentListViewController : BaseViewController

@property (nonatomic, strong) DynamicCommentModel *model;

@property (nonatomic, strong) NSString *dynamicId;

@end

