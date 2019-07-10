//
//  TeacherDetailNoteViewController.h
//  STUDIES
//
//  Created by happyi on 2019/6/3.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>
#import "NoteSearchModel.h"
@interface TeacherDetailNoteViewController : UIViewController<JXPagerViewListViewDelegate>

/** 导师id */
@property (nonatomic, strong) NSString *ubid;
/** 选择游记的block */
@property (nonatomic, copy) void(^selectNoteBlock)(NoteSearchModel *model);

@end

