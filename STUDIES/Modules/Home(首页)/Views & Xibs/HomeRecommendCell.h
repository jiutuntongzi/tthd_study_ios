//
//  HomeRecommendCell.h
//  STUDIES
//
//  Created by happyi on 2019/3/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTheamModel.h"

@interface HomeRecommendCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
/** 子视图 */
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
/** 选择活动的block */
@property (nonatomic, copy) void(^selectedActivity)(HomeTheamModel *model);
/** 推荐活动 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

