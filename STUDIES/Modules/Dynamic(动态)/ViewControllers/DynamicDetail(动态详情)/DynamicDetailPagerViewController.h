//
//  DynamicDetailPagerViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"
#import "JXPagerView.h"
#import "DynamicListModel.h"

@interface DynamicDetailPagerViewController : BaseViewController<JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, strong) DynamicListModel *dynamicModel;

@end

