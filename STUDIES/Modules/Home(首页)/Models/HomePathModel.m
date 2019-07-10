//
//  HomePathModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomePathModel.h"

@implementation HomePathModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [HomePathModel modelWithDictionary:dict];
        self.pId = dict[@"id"];
    }
    
    return self;
}

@end
