//
//  TopicPagingViewController.h
//  STUDIES
//
//  Created by happyi on 2019/4/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"
#import "JXPagerView.h"
#import "TopicListModel.h"

@interface TopicDetailPagerViewController : BaseViewController<JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;

- (JXPagerView *)preferredPagingView;

@property (nonatomic, strong) TopicListModel *topicModel;

@property (nonatomic, strong) NSString *topicId;

@end

