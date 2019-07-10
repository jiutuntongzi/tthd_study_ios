//
//  HomeLiveCell.h
//  STUDIES
//
//  Created by happyi on 2019/3/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeLiveCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
/** 子视图 */
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
/** 选择直播的block */
@property (nonatomic, copy) void(^selectedLiveBlock)(void);
@end

NS_ASSUME_NONNULL_END
