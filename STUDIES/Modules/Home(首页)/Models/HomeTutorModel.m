//
//  HomeTutorModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeTutorModel.h"

@implementation HomeTutorModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [HomeTutorModel modelWithDictionary:dict];
        self.tId = dict[@"id"];
    }
    
    return self;
}

@end
