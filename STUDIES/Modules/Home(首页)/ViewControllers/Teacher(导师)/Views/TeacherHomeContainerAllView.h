//
//  TeacherHomeContainerView.h
//  STUDIES
//
//  Created by happyi on 2019/5/15.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>
#import "TeacherModel.h"
#import "TeacherRequestManagerClass.h"
#import "TeacherTypeModel.h"

@interface TeacherHomeContainerAllView : UIView<JXPagerViewListViewDelegate, UITableViewDataSource, UITableViewDelegate, RequestManagerDelegate>
{
    int _offset;
    TeacherRequestManagerClass *_requestManager;
    UITableView *_mainTableView;
    NSMutableArray *_dataArray;
}
/** scrollBlock */
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
/** 选择导师的回调 */
@property (nonatomic, copy) void(^selectedTeacherBlock)(TeacherModel *model);
/** 选择的分类 */
@property (nonatomic, strong) TeacherTypeModel *selectedModel;

@end

