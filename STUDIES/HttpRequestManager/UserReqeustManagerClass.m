//
//  UserReqeustManagerClass.m
//  STUDIES
//
//  Created by happyi on 2019/5/30.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "UserReqeustManagerClass.h"

@implementation UserReqeustManagerClass

#pragma mark - 获取用户的收藏夹
-(void)getUserCollectWithOffset:(NSString *)offset limit:(NSString *)limit token:(NSString *)token requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      offset, @"offset",
                                      limit, @"limit",
                                      token, @"token",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_GETWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            [self.delegate requestSuccess:response[@"data"][@"list"] requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 修改用户信息
-(void)postUserInfoWithAvatar:(NSString *)avatar username:(NSString *)username nickname:(NSString *)nickname bio:(NSString *)bio password:(NSString *)password gender:(NSString *)gender token:(NSString *)token requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      avatar, @"avatar",
                                      username, @"username",
                                      nickname, @"nickname",
                                      bio, @"bio",
                                      password, @"password",
                                      token, @"token",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            [self.delegate requestSuccess:response[@"data"] requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 获取用户个人中心信息
-(void)getUserIndexWithToken:(NSString *)token requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      token, @"token",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_GETWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            [self.delegate requestSuccess:response[@"data"] requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

@end
