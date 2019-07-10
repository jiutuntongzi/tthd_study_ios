//
//  DynamicRequestManagerClass.h
//  STUDIES
//
//  Created by happyi on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "RequestManager.h"

@interface DynamicRequestManagerClass : RequestManager

/**
 获取动态列表

 @param token token
 @param type 类型 1、我的关注 2、我的动态 3、导师动态
 @param ubId 导师id
 @param topicsId 话题id
 @param lastId 上次更新的第一个id
 @param requestName 请求方法名
 */
-(void)getDynamicListWithToken:(NSString *)token
                          type:(NSString *)type
                          ubId:(NSString *)ubId
                      topicsId:(NSString *)topicsId
                        lastId:(NSString *)lastId
                          page:(NSString *)page
                      pageSize:(NSString *)pageSize
                   requestType:(NSString *)requestType
                          sort:(NSString *)sort
                   requestName:(NSString *)requestName;

/**
 发布动态

 @param token token
 @param isFoot 是否是足迹打卡
 @param latitude 精度
 @param latitude 纬度
 @param noteId 关联的游记id
 @param topicIds 关联的话题
 @param dynamic 动态对象
 @param requestName 请求方法名
 */
-(void)postSubmitDynamicWithToken:(NSString *)token
                           isFoot:(NSString *)isFoot
                         latitude:(NSString *)latitude
                        longitude:(NSString *)longitude
                           noteId:(NSString *)noteId
                         topicIds:(NSArray *)topicIds
                          dynamic:(NSDictionary *)dynamic
                      requestName:(NSString *)requestName;

/**
 获取动态的评论列表

 @param token token
 @param dynamicId 动态id
 @param parentId 父id
 @param page 页码
 @param pageSize 请求数
 @param requestName 请求方法名
 */
-(void)postDynamicCommentListWithToken:(NSString *)token
                             dynamicId:(NSString *)dynamicId
                              parentId:(NSString *)parentId
                                  page:(NSString *)page
                              pageSize:(NSString *)pageSize
                           requestName:(NSString *)requestName;

/**
 获取动态点赞列表

 @param dynamicId 动态id
 @param requestName 请求方法名
 */
-(void)postDynamicLikeListWithDynamicId:(NSString *)dynamicId
                            requestName:(NSString *)requestName;

/**
 动态点赞

 @param token token
 @param dynamicId 动态id
 @param requestName 请求方法名
 */
-(void)postDynamicPraiseWithToken:(NSString *)token
                        dynamicId:(NSString *)dynamicId
                      reqeustName:(NSString *)requestName;

/**
 搜索动态

 @param key 关键字
 @param ubid ubid
 @param requestName 请求方法名
 */
-(void)postDynamicSearchWithKey:(NSString *)key
                           ubId:(NSString *)ubid
                    requestName:(NSString *)requestName;

/**
 发布动态评论

 @param token token
 @param parentId 父id
 @param dynamicId 动态id
 @param content 内容
 @param contentImages 图片
 @param requestName 请求方法名
 */
-(void)postDynamicCommentWithToken:(NSString *)token
                          parentId:(NSString *)parentId
                         dynamicId:(NSString *)dynamicId
                           content:(NSString *)content
                     contentImages:(NSString *)contentImages
                       requestName:(NSString *)requestName;

/**
 动态评论点赞

 @param commentId 评论id
 @param token token
 */
-(void)postPraiseDynamicCommentWithCommentId:(NSString *)commentId
                                       token:(NSString *)token
                                 requestName:(NSString *)requestName;

@end

