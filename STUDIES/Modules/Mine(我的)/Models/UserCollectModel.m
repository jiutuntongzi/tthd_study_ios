//
//  UserCollectModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/30.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "UserCollectModel.h"

@implementation UserCollectModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [UserCollectModel modelWithDictionary:dict];
    }
    
    return self;
}

@end
