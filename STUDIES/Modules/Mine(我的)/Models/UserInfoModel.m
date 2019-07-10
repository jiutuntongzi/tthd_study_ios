//
//  UserInfoModel.m
//  STUDIES
//
//  Created by happyi on 2019/4/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [UserInfoModel modelWithDictionary:dict];
    }
    
    return self;
}

+(NSArray *)bg_uniqueKeys
{
    return @[@"user_id"];
}

+(NSArray *)bg_ignoreKeys
{
    return @[@"createtime", @"expires_in", @"expiretime", @"id", @"score"];
}

@end
