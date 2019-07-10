//
//  UserIndexModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/31.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "UserIndexModel.h"

@implementation UserIndexModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [UserIndexModel modelWithDictionary:dict];
    }
    
    return self;
}

@end
