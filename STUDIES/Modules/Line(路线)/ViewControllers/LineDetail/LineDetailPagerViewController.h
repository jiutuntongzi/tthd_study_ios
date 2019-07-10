//
//  LineDetailPagerViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/9.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"
#import "JXPagerView.h"

@interface LineDetailPagerViewController : BaseViewController<JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;

- (JXPagerView *)preferredPagingView;

/** 路线id */
@property (nonatomic, strong) NSString *lineId;
/** 导师id */
@property (nonatomic, strong) NSString *tutorId;

@end

