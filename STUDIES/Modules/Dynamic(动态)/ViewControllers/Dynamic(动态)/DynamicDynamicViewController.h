//
//  DynamicDynamicViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/10.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryListContainerView.h"
#import "DynamicListModel.h"

@interface DynamicDynamicViewController : UIViewController<JXCategoryListContentViewDelegate>

/** 选择动态的回调 */
@property(nonatomic, copy) void(^selectDynamicBlock)(DynamicListModel *model);
/** 选择用户的block */
@property(nonatomic, copy) void(^selectUserBlock)(NSString *ubId, NSString *userType);
/** 选择话题的block */
@property(nonatomic, copy) void(^selectTopicBlock)(NSString *topicId);
/** 选择游记的block */
@property(nonatomic, copy) void(^selectNoteBlock)(NSString *noteId);

@end
