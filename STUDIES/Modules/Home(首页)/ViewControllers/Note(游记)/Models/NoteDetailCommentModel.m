//
//  NoteDetailCommentModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/22.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "NoteDetailCommentModel.h"

@implementation NoteDetailCommentModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [NoteDetailCommentModel modelWithDictionary:dict];
        self.commentID = dict[@"id"];
    }
    
    return self;
}

@end
