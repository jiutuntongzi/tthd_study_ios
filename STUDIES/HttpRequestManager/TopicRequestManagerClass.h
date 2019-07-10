//
//  TopicRequestManagerClass.h
//  STUDIES
//
//  Created by happyi on 2019/5/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "RequestManager.h"

@interface TopicRequestManagerClass : RequestManager

/**
 获取话题列表

 @param ishot 话题类型 0、普通 1、热门
 @param isnew 最新话题
 @param requestName 请求方法名
 */
-(void)getTopicListWithIsHot:(NSString *)ishot
                       isNew:(NSString *)isnew
                 requestName:(NSString *)requestName;

/**
 获取话题详情

 @param topicId 话题id
 @param requestName 请求方法名
 */
-(void)getTopicDetailWithTopicId:(NSString *)topicId
                     requestName:(NSString *)requestName;

/**
 搜索话题

 @param keyword 关键字
 @param page 页数
 @param pageSize 请求数
 @param requestName 请求方法名
 */
-(void)postTopicSearchWithKeyword:(NSString *)keyword
                             page:(NSString *)page
                         pageSize:(NSString *)pageSize
                      requestName:(NSString *)requestName;

/**
 关注话题

 @param topicId 话题id
 @param token token
 @param requestName 请求方法名
 */
-(void)postFollowTopicWithTopicId:(NSString *)topicId
                            token:(NSString *)token
                      requestName:(NSString *)requestName;

/**
 关注的话题

 @param token token
 @param page 页码
 @param pageSize 数据量
 @param requestName 请求方法名
 */
-(void)getTopicFollowListWithToken:(NSString *)token
                              page:(NSString *)page
                          pageSize:(NSString *)pageSize
                       requestName:(NSString *)requestName;
@end

