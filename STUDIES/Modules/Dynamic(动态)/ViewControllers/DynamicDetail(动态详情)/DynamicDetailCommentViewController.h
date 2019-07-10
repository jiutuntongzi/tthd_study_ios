//
//  DynamicDetailCommentViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>
#import "DynamicListModel.h"
#import "DynamicCommentModel.h"
@interface DynamicDetailCommentViewController : UIViewController<JXPagerViewListViewDelegate>

@property (nonatomic, strong) DynamicListModel *dynamicModel;

@property (nonatomic, copy) void(^replyBlock)(NSString *dynamicId, NSString *commentId);

@property (nonatomic, copy) void(^replyListBlock)(NSString *dynamicId, DynamicCommentModel *model);

/** 选择用户的block */
@property (nonatomic, copy) void(^selectUserBlock)(NSString *ubId, NSString *userType);
/** 选择话题的block */
@property (nonatomic, copy) void(^selectTopicBlock)(NSString *topicId);
/** 选择游记的block */
@property (nonatomic, copy) void(^selectNoteBlock)(NSString *noteId);

-(void)refresh;

@end

