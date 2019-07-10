//
//  LiveHomeContainerView.h
//  STUDIES
//
//  Created by happyi on 2019/5/15.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>


@interface LiveHomeContainerView : UIView<JXPagerViewListViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

/** 主视图 */
@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
/** 选择直播的回调 */
@property (nonatomic, copy) void(^selectedLiveBlock)(void);

@end

