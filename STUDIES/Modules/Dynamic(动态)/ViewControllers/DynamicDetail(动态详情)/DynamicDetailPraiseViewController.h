//
//  DynamicDetailPraiseViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>
#import "DynamicListModel.h"

@interface DynamicDetailPraiseViewController : UIViewController<JXPagerViewListViewDelegate>

@property (nonatomic, strong) DynamicListModel *dynamicModel;

-(void)refresh;

@end
