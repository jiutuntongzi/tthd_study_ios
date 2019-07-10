//
//  TopicHomePagerViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/15.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"
#import "JXPagerView.h"

@interface TopicHomePagerViewController : BaseViewController<JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;

- (JXPagerView *)preferredPagingView;

@end

