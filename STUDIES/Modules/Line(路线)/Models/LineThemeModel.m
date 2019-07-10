//
//  LineThemeModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineThemeModel.h"

@implementation LineThemeModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [LineThemeModel modelWithDictionary:dict];
        self.tId = dict[@"id"];
    }
    
    return self;
}

@end
