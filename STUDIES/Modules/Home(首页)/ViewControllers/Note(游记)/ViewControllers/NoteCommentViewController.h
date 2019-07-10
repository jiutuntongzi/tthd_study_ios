//
//  NoteCommentViewController.h
//  STUDIES
//
//  Created by happyi on 2019/4/26.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"
#import "NoteDetailCommentModel.h"

@interface NoteCommentViewController : BaseViewController

/** 评论的数据模型 */
@property (nonatomic, strong) NoteDetailCommentModel *model;
/** 游记id */
@property (nonatomic, strong) NSString *noteId;

@end

