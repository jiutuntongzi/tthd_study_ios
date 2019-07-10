//
//  HomeCallModel.m
//  STUDIES
//
//  Created by happyi on 2019/6/11.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeCallModel.h"

@implementation HomeCallModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [HomeCallModel modelWithDictionary:dict];
    }
    
    return self;
}

@end
