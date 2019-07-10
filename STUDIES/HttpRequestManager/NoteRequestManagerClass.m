//
//  NoteRequestManagerClass.m
//  STUDIES
//
//  Created by happyi on 2019/5/20.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "NoteRequestManagerClass.h"

@implementation NoteRequestManagerClass

#pragma mark - 游记搜索
-(void)getSearchNoteWithKeyword:(NSString *)keyword type:(nonnull NSString *)type offset:(nonnull NSString *)offset limit:(nonnull NSString *)limit token:(NSString *)token requestName:(nonnull NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      keyword, @"title",
                                      offset, @"offset",
                                      type, @"type",
                                      token, @"token",
                                      limit, @"limit", nil];
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

#pragma mark - 游记详情
-(void)getNoteDetailWithNoteId:(NSString *)noteId token:(NSString *)token requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      noteId, @"travels_id",
                                      token, @"token", nil];
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

#pragma mark - 获取游记详情的评论列表
-(void)getNoteDetailCommentsWithNoteId:(NSString *)noteId offset:(NSString *)offset limit:(NSString *)limit token:(NSString *)token requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      noteId, @"travels_id",
                                      offset, @"offset",
                                      limit, @"limit",
                                      token, @"token",
                                      @"1", @"user_type",
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

#pragma mark - 查询游记列表
-(void)getNoteListWithType:(NSString *)type sort_type:(NSString *)sort_type offset:(NSString *)offset limit:(NSString *)limit token:(NSString *)token requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      type, @"type",
                                      sort_type, @"sort_type",
                                      offset, @"offset",
                                      limit, @"limit",
                                      token, @"token",nil];
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

#pragma mark - 收藏游记
-(void)postCollectNoteWithNoteId:(NSString *)noteId token:(NSString *)token requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      noteId, @"travels_id",
                                      token, @"token",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            [self.delegate requestSuccess:nil requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 关注用户
-(void)postFollowWithAboutType:(NSString *)about_type aboutId:(NSString *)about_id token:(NSString *)token requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      about_type, @"about_type",
                                      about_id, @"about_id",
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

#pragma mark - 举报
-(void)getReportWithToken:(NSString *)token position:(NSString *)position content:(NSString *)content complaints:(NSString *)complaints foreign_id:(NSString *)foreign_id requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      token, @"token",
                                      position, @"position",
                                      content, @"content",
                                      complaints, @"complaints",
                                      foreign_id, @"foreign_id",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            [self.delegate requestSuccess:nil requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 获取回复列表
-(void)getNoteReplyListWithNoteID:(NSString *)noteId reply_id:(NSString *)reply_id offset:(NSString *)offset limit:(NSString *)limit token:(NSString *)token requestName:(nonnull NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      noteId, @"travels_id",
                                      reply_id, @"reply_id",
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
            [self.delegate requestSuccess:response[@"data"][@"reply"] requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 游记点赞
-(void)postPraiseNoteWithNoteId:(NSString *)noteId type:(NSString *)type replyId:(NSString *)replyId token:(NSString *)token requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      noteId, @"travels_id",
                                      replyId, @"reply_id",
                                      type, @"live_label",
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

#pragma mark - 发布游记
-(void)postSubmitNoteWithTravels:(NSDictionary *)travels userType:(NSString *)userType token:(NSString *)token requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      travels, @"travels",
                                      userType, @"user_type",
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

#pragma mark - 游记评论
-(void)postNoteCommentWithNoteId:(NSString *)noteId replyId:(NSString *)replyId type:(NSString *)type content:(NSString *)content img:(NSString *)img token:(NSString *)token requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      noteId, @"travels_id",
                                      replyId, @"reply_id",
                                      type, @"type",
                                      content, @"content",
                                      img, @"img",
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

#pragma mark - 获取用户详情游记列表
-(void)getUserNoteListWithUbId:(NSString *)ubid offset:(NSString *)offset limit:(NSString *)limit requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      ubid, @"ub_id",
                                      offset, @"offset",
                                      limit, @"limit",
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

@end
