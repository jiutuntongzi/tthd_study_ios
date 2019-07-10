//
//  DynamicListModel.m
//  STUDIES
//
//  Created by 花想容 on 2019/6/1.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicListModel.h"

@implementation DynamicListModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [DynamicListModel modelWithDictionary:dict];
        self.dynamicId = dict[@"id"];
    }
    
    return self;
}

@end
