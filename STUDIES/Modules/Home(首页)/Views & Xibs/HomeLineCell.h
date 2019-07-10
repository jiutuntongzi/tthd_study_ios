//
//  HomeLineCell.h
//  STUDIES
//
//  Created by happyi on 2019/3/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePathModel.h"

@interface HomeLineCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

/** 内容视图 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 选择路线的block */
@property (nonatomic, copy) void(^selectedLineBlock)(HomePathModel *model);
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

