//
//  TeacherTypeModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherTypeModel.h"

@implementation TeacherTypeModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [TeacherTypeModel modelWithDictionary:dict];
        self.typeId = dict[@"id"];
    }
    
    return self;
}

@end
