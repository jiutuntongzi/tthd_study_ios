//
//  HomeTeacherCell.h
//  STUDIES
//
//  Created by happyi on 2019/3/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTutorModel.h"

@interface HomeTeacherCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
/** 子视图 */
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
/** 选择导师的block */
@property (nonatomic, copy) void(^selectedTeacherBlock)(HomeTutorModel *model);
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

