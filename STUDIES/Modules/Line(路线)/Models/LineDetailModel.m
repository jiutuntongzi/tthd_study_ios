//
//  LineDetailModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/27.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineDetailModel.h"

@implementation LineDetailModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [LineDetailModel modelWithDictionary:dict];
        self.lineId = dict[@"id"];
    }
    
    return self;
}

@end
