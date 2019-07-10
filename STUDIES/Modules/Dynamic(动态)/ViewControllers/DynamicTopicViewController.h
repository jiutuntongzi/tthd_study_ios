//
//  DynamicTopicViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "QMUIModalPresentationViewController.h"
#import "TopicListModel.h"

@interface DynamicTopicViewController : QMUIModalPresentationViewController

/** 选择话题 */
@property(nonatomic, copy) void(^selectedTopic)(TopicListModel *model, NSMutableArray <TopicListModel *> *topicArray);;

@end

