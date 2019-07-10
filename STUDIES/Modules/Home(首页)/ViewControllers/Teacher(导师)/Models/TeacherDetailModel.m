//
//  TeacherDetailModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherDetailModel.h"

@implementation TeacherDetailModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [TeacherDetailModel modelWithDictionary:dict];
    }
    
    return self;
}

@end
