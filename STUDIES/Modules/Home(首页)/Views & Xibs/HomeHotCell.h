//
//  HomeHotCell.h
//  STUDIES
//
//  Created by happyi on 2019/3/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTopicModel.h"

@interface HomeHotCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
/** 子视图 */
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
/** 选择话题的block */
@property (nonatomic, copy) void(^selectedTopic)(NSString *topicId);
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end


