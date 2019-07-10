//
//  TeacherLiveViewController.h
//  STUDIES
//
//  Created by happyi on 2019/3/25.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>

@interface TeacherDetailLiveViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, JXPagerViewListViewDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

/** 选择直播的block */
@property (nonatomic, copy) void(^selectedLiveBlock)(void);

@end
