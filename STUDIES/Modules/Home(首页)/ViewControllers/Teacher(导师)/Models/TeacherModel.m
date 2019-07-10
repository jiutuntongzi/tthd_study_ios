//
//  TeacherModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherModel.h"

@implementation TeacherModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [TeacherModel modelWithDictionary:dict];
    }
    
    return self;
}

@end
