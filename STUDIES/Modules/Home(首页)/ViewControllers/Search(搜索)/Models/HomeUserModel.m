//
//  HomeUserModel.m
//  STUDIES
//
//  Created by happyi on 2019/6/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeUserModel.h"

@implementation HomeUserModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [HomeUserModel modelWithDictionary:dict];
        self.userId = dict[@"id"];
    }
    
    return self;
}

@end
