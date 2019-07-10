//
//  TopicHomeContainerView.h
//  STUDIES
//
//  Created by happyi on 2019/5/15.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>
#import "TopicListModel.h"
@interface TopicHomeContainerView : UIView<JXPagerViewListViewDelegate, UITableViewDataSource, UITableViewDelegate>

/** 主视图 */
@property(nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 选择话题的block */
@property (nonatomic, copy) void(^selectTopicBlock)(TopicListModel *model);

@end

