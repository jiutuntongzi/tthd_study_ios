//
//  DynamicNoteViewController.h
//  STUDIES
//
//  Created by happyi on 2019/6/5.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "QMUIModalPresentationViewController.h"
#import "NoteSearchModel.h"

@interface DynamicNoteViewController : QMUIModalPresentationViewController

@property (nonatomic, copy) void(^selectedNoteBlock)(NoteSearchModel *model);

@end

