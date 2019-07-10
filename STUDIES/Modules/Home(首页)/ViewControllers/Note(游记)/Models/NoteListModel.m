//
//  NoteListModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/23.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "NoteListModel.h"

@implementation NoteListModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [NoteListModel modelWithDictionary:dict];
        self.noteId = dict[@"id"];
    }
    
    return self;
}

@end
