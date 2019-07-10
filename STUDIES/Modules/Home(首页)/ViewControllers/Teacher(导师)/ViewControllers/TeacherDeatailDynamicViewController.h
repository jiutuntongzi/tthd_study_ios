//
//  TeacherDynamicViewController.h
//  STUDIES
//
//  Created by happyi on 2019/3/25.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>
#import "TeacherDetailModel.h"
#import "DynamicListModel.h"
@interface TeacherDeatailDynamicViewController : UIViewController<JXPagerViewListViewDelegate>


/** 导师详情 */
@property (nonatomic, strong) TeacherDetailModel *detailModel;
/** 选择用户的block */
@property (nonatomic, copy) void(^selectUserBlock)(NSString *ubId, NSString *userType);
/** 选择话题的block */
@property (nonatomic, copy) void(^selectTopicBlock)(NSString *topicId);
/** 选择游记的block */
@property   (nonatomic, copy) void(^selectNoteBlock)(NSString *noteId);
/** 选择动态的block */ 
@property (nonatomic, copy) void(^selectedDynamicBlock)(DynamicListModel *model);

@end

