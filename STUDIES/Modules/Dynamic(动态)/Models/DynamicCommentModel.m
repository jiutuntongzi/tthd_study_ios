//
//  DyanmicCommentModel.m
//  STUDIES
//
//  Created by happyi on 2019/6/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicCommentModel.h"

@implementation DynamicCommentModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [DynamicCommentModel modelWithDictionary:dict];
        self.commentId = dict[@"id"];
    }
    
    return self;
}

@end
