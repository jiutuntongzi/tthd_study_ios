//
//  LineThemeItemModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineThemeItemModel.h"

@implementation LineThemeItemModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [LineThemeItemModel modelWithDictionary:dict];
        self.pId = dict[@"id"];
    }
    
    return self;
}

@end
