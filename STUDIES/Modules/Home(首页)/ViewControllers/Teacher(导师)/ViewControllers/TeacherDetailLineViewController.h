//
//  TeacherLineViewController.h
//  STUDIES
//
//  Created by happyi on 2019/3/25.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>


@interface TeacherDetailLineViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, JXPagerViewListViewDelegate>

/** 选择路线的block */
@property (nonatomic, copy) void(^selectedLineBlock)(void);
/** 导师ID */
@property (nonatomic, strong) NSString *ub_id;

@end

