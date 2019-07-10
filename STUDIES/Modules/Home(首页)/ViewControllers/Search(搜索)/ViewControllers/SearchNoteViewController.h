//
//  SearchNoteViewController.h
//  STUDIES
//
//  Created by 花想容 on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryListContainerView.h"
#import "NoteSearchModel.h"

@interface SearchNoteViewController : UIViewController<JXCategoryListContentViewDelegate>

/** 搜索的关键字 */
@property (nonatomic, strong) NSString *keyword;
/** 选择游记的block */
@property (nonatomic, copy) void(^selectNoteBlock)(NoteSearchModel *model);

@end

