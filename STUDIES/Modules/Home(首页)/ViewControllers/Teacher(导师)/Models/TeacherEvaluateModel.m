//
//  TeacherEvaluateModel.m
//  STUDIES
//
//  Created by 花想容 on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherEvaluateModel.h"

@implementation TeacherEvaluateModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [TeacherEvaluateModel modelWithDictionary:dict];
        self.evaluateId = dict[@"id"];
    }
    
    return self;
}

@end
