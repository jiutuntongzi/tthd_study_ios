//
//  LineHotPlaceCell.h
//  STUDIES
//
//  Created by happyi on 2019/5/8.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineDestinationModel.h"

@interface LineHotPlaceCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

/** 子视图 */
@property(nonatomic, strong, readonly) UICollectionView *collectionView;
/** 选择item的回调 */
@property(nonatomic, copy) void(^selectItemBlock)(NSString *dId);
/** 数据源 */
@property(nonatomic, strong) NSMutableArray *dataArray;
@end

