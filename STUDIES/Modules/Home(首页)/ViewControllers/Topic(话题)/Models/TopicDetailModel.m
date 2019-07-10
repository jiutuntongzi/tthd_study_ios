//
//  TopicDetailModel.m
//  STUDIES
//
//  Created by happyi on 2019/6/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TopicDetailModel.h"

@implementation TopicDetailModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [TopicDetailModel modelWithDictionary:dict];
        self.topicId = dict[@"id"];
        self.title = [NSString stringWithFormat:@"#%@#", dict[@"title"]];
    }
    
    return self;
}

@end
