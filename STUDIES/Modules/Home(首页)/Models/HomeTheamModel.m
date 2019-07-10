//
//  HomeTheamModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeTheamModel.h"

@implementation HomeTheamModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [HomeTheamModel modelWithDictionary:dict];
        self.tId = dict[@"id"];
    }
    
    return self;
}

@end
