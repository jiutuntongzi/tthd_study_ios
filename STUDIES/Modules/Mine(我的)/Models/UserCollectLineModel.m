//
//  UserCollectLineModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/30.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "UserCollectLineModel.h"

@implementation UserCollectLineModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [UserCollectLineModel modelWithDictionary:dict];
    }
    
    return self;
}

@end
