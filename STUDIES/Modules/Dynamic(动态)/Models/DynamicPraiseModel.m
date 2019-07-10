//
//  DynamicPraiseModel.m
//  STUDIES
//
//  Created by happyi on 2019/6/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicPraiseModel.h"

@implementation DynamicPraiseModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [DynamicPraiseModel modelWithDictionary:dict];
    }
    
    return self;
}

@end
