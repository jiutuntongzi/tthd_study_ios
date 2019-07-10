//
//  HomeRequestManagerClass.m
//  STUDIES
//
//  Created by happyi on 2019/5/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeRequestManagerClass.h"

@implementation HomeRequestManagerClass

#pragma mark - 获取首页
-(void)getHomeWithUbId:(NSString *)ubId requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      ubId, @"ub_id",
                                      nil];
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_GETWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            [self.delegate requestSuccess:response[@"data"] requestName:requestName];
        }else{
            [self.delegate requestFailure:nil requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 首页搜索
-(void)postHomeSearchWithKey:(NSString *)key token:(NSString *)token type:(NSString *)type page:(NSString *)page pageSize:(NSString *)pageSize requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      key, @"key",
                                      token, @"token",
                                      type, @"type",
                                      page, @"page",
                                      pageSize, @"page_size",
                                      nil];
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            [self.delegate requestSuccess:response[@"data"][@"users"] requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

@end
