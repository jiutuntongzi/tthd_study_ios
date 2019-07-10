//
//  LineDestinationModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineDestinationModel.h"

@implementation LineDestinationModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [LineDestinationModel modelWithDictionary:dict];
        self.dId = dict[@"id"];
    }
    
    return self;
}

@end
