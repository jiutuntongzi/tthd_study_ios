//
//  NoteHomeContainerView.h
//  STUDIES
//
//  Created by happyi on 2019/5/15.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>
#import "NoteListModel.h"
#import "TeacherTypeModel.h"
#import "NoteRequestManagerClass.h"

@interface NoteHomeContainerAllView : UIView<JXPagerViewListViewDelegate, UITableViewDataSource, UITableViewDelegate, RequestManagerDelegate>
{
    int _offset;
    NoteRequestManagerClass *_requestManager;
    UITableView *_mainTableView;
    NSMutableArray *_dataArray;
}
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
/** 选择游记的回调 */
@property (nonatomic, copy) void(^selectedNoteBlock)(NoteListModel *model);
/** 选择的分类 */
@property (nonatomic, strong) TeacherTypeModel *selectedModel;
/** 选择图片的block */
@property (nonatomic, copy) void(^tapImageBlock)(NSArray *imageUrls, NSInteger currentIndex);

@end

