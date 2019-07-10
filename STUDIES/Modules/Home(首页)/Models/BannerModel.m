//
//  BannerModel.m
//  STUDIES
//
//  Created by happyi on 2019/5/23.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [BannerModel modelWithDictionary:dict];
        self.bannerId = dict[@"id"];
    }
    
    return self;
}

@end
