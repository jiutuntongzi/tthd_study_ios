//
//  UserModel.m
//  STUDIES
//
//  Created by happyi on 2019/6/5.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [UserModel modelWithDictionary:dict];
    }
    
    return self;
}

@end
