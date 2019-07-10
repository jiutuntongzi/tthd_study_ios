//
//  SearchTopicViewController.h
//  STUDIES
//
//  Created by 花想容 on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryListContainerView.h"
#import "TopicListModel.h"

@interface SearchTopicViewController : UIViewController<JXCategoryListContentViewDelegate>

/** 搜索的关键字 */
@property (nonatomic, strong) NSString *keyword;
/** 选择话题的block */
@property (nonatomic, copy) void(^selectTopicBlock)(TopicListModel *model);

@end

