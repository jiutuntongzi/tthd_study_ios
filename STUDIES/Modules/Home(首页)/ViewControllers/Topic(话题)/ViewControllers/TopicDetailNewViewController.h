//
//  TopicNewDetailViewController.h
//  STUDIES
//
//  Created by happyi on 2019/4/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"
#import <JXPagerView.h>
#import "TopicDetailModel.h"
#import "DynamicListModel.h"

@interface TopicDetailNewViewController : UIViewController<JXPagerViewListViewDelegate>

@property (nonatomic, assign) CGFloat customHeight;

/** 话题详情 */
@property (nonatomic, strong) TopicDetailModel *detailModel;
/** 请求结束 */
@property (nonatomic, copy) void(^requestFinishiBlock)(void);

-(void)refresh;


/** 选择动态的回调 */
@property(nonatomic, copy) void(^selectDynamicBlock)(DynamicListModel *model);
/** 选择用户的block */
@property(nonatomic, copy) void(^selectUserBlock)(NSString *ubId, NSString *userType);
/** 选择话题的block */
@property(nonatomic, copy) void(^selectTopicBlock)(NSString *topicId);
/** 选择游记的block */
@property(nonatomic, copy) void(^selectNoteBlock)(NSString *noteId);

@end

