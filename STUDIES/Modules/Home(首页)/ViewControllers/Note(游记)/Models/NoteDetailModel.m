//
//  NoteDetailModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/20.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "NoteDetailModel.h"

@implementation NoteDetailModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [NoteDetailModel modelWithDictionary:dict];
        self.noteId = dict[@"id"];
    }
    
    return self;
}

@end
