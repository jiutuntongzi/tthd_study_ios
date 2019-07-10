//
//  NoteHomeContainerTopView.h
//  STUDIES
//
//  Created by happyi on 2019/5/15.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>
#import "NoteListModel.h"
#import "NoteRequestManagerClass.h"

@interface NoteHomeContainerTopView : UIView<JXPagerViewListViewDelegate, UITableViewDataSource, UITableViewDelegate, RequestManagerDelegate>
{
    int _offset;
    NoteRequestManagerClass *_requestManager;
    UITableView *_mainTableView;
    NSMutableArray *_dataArray;
}

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
/** 选择游记的回调 */
@property (nonatomic, copy) void(^selectedNoteBlock)(NoteListModel *model);
/** 请求完成 */
@property (nonatomic, copy) void(^requestFinishBlock)(void);
/** 选择图片的block */
@property (nonatomic, copy) void(^tapImageBlock)(NSArray *imageUrls, NSInteger currentIndex);

-(void)refresh;

@end

