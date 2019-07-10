//
//  OCExampleViewController.h
//  JXPagingView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "TeacherDetailHeaderView.h"
#import "JXCategoryTitleView.h"
#import "BaseViewController.h"
static const CGFloat JXTableHeaderViewHeight = 170;
static const CGFloat JXheightForHeaderInSection = 40;

@interface TeacherDetailPagerViewController : BaseViewController <JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, strong) TeacherDetailHeaderView *userHeaderView;
@property (nonatomic, strong, readonly) JXCategoryTitleView *categoryView;

/** 导师id */
@property (nonatomic, strong) NSString *ub_id;
/** 用户类型 */
@property (nonatomic, strong) NSString *userType;
/** 姓名 */
@property (nonatomic, strong) NSString *name;
/** 头像 */
@property (nonatomic, strong) NSString *avatar;

@end
