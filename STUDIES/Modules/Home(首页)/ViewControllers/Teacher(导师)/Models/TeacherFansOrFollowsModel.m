//
//  TeacherFansOrFollowsModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherFansOrFollowsModel.h"

@implementation TeacherFansOrFollowsModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [TeacherFansOrFollowsModel modelWithDictionary:dict];
    }
    
    return self;
}

@end
