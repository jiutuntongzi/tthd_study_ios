//
//  TrackSubmitViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/8.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "TopicListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TrackSubmitViewController : BaseViewController

/** 选择的地址 */
@property(nonatomic, strong) BMKPoiInfo *selectedInfo;
/** 当前城市 */
@property(nonatomic, strong) NSString *city;
/** 游记id */
@property(nonatomic, strong) NSString *noteId;
/** 游记标题 */
@property(nonatomic, strong) NSString *noteTitle;
/** 话题 */
@property(nonatomic, strong) TopicListModel *topicModel;

@end

NS_ASSUME_NONNULL_END
