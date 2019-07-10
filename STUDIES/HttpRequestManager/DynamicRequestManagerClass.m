//
//  DynamicRequestManagerClass.m
//  STUDIES
//
//  Created by happyi on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicRequestManagerClass.h"

@implementation DynamicRequestManagerClass

#pragma mark - 获取动态列表
-(void)getDynamicListWithToken:(NSString *)token type:(NSString *)type ubId:(NSString *)ubId topicsId:(NSString *)topicsId lastId:(NSString *)lastId page:(NSString *)page pageSize:(NSString *)pageSize requestType:(NSString *)requestType sort:(NSString *)sort requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      token, @"token",
                                      type, @"type",
                                      ubId, @"ub_id",
                                      topicsId, @"topics_id",
                                      lastId, @"last_id",
                                      page, @"page",
                                      pageSize, @"page_size",
                                      requestType, @"request_type",
                                      sort, @"sort",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_GETWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1){
            
            [self.delegate requestSuccess:response[@"data"][@"list"] requestName:requestName];
        }else{
            [self.delegate requestFailure:nil requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 发布动态
-(void)postSubmitDynamicWithToken:(NSString *)token isFoot:(NSString *)isFoot latitude:(NSString *)latitude longitude:(NSString *)longitude noteId:(NSString *)noteId topicIds:(NSArray *)topicIds dynamic:(NSDictionary *)dynamic requestName:(NSString *)requestName
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dynamic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    jsonStr = [MyTools utf8ToUnicode:jsonStr];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      token, @"token",
                                      isFoot, @"is_foot",
                                      latitude, @"latitude",
                                      longitude, @"longitude",
                                      noteId, @"travel_id",
                                      topicIds, @"topic_ids",
                                      jsonStr, @"dynamic",
                                      nil];
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            [self.delegate requestSuccess:response[@"data"] requestName:requestName];
            NSLog(@"%@", response[@"msg"]);
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 获取动态的评论列表
-(void)postDynamicCommentListWithToken:(NSString *)token dynamicId:(NSString *)dynamicId parentId:(NSString *)parentId page:(NSString *)page pageSize:(NSString *)pageSize requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      token, @"token",
                                      dynamicId, @"dynamic_id",
                                      parentId, @"parent_id",
                                      page, @"page",
                                      pageSize, @"page_size",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1){
            
            [self.delegate requestSuccess:response[@"data"][@"list"] requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 获取动态的点赞列表
-(void)postDynamicLikeListWithDynamicId:(NSString *)dynamicId requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      dynamicId, @"id",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1){
            
            [self.delegate requestSuccess:response[@"data"][@"list"] requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 动态点赞
-(void)postDynamicPraiseWithToken:(NSString *)token dynamicId:(NSString *)dynamicId reqeustName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      dynamicId, @"id",
                                      token, @"token",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1){
            
            [self.delegate requestSuccess:response[@"data"][@"list"] requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 搜索动态
-(void)postDynamicSearchWithKey:(NSString *)key ubId:(NSString *)ubid requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      ubid, @"ub_id",
                                      key, @"key",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1){
            
            [self.delegate requestSuccess:response[@"data"][@"list"] requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 发布动态评论
-(void)postDynamicCommentWithToken:(NSString *)token parentId:(NSString *)parentId dynamicId:(NSString *)dynamicId content:(NSString *)content contentImages:(NSString *)contentImages requestName:(NSString *)requestName
{
    NSString *contentStr = [content stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      token, @"token",
                                      parentId, @"parent_id",
                                      dynamicId, @"dynamic_id",
                                      [MyTools utf8ToUnicode:contentStr], @"content",
                                      contentImages, @"content_images",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1){
            
            [self.delegate requestSuccess:response[@"data"] requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 动态评论点赞
-(void)postPraiseDynamicCommentWithCommentId:(NSString *)commentId token:(NSString *)token requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      token, @"token",
                                      commentId, @"id",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1){
            
            [self.delegate requestSuccess:response[@"data"] requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

@end
