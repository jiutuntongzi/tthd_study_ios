//
//  TopicListModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TopicListModel.h"

@implementation TopicListModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [TopicListModel modelWithDictionary:dict];
        self.topicId = dict[@"id"];
        self.title = [NSString stringWithFormat:@"#%@#", dict[@"title"]];
    }
    
    return self;
}

@end
