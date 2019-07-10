//
//  LineDetailViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/9.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"
#import <JXPagerView.h>
#import "LineDetailModel.h"

@interface LineDetailViewController : UIViewController<JXPagerViewListViewDelegate>

/** 数据模型 */
@property (nonatomic, strong) LineDetailModel *detailModel;

@end

