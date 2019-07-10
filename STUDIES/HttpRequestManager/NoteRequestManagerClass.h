//
//  NoteRequestManagerClass.h
//  STUDIES
//
//  Created by happyi on 2019/5/20.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "RequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteRequestManagerClass : RequestManager

/**
 游记搜索

 @param keyword 关键词
 @param type 类型 1、搜索 2、我的游记
 @param offset 限制结果数量
 @param limit 查询条数
 */
-(void)getSearchNoteWithKeyword:(NSString *)keyword
                           type:(NSString *)type
                         offset:(NSString *)offset
                          limit:(NSString *)limit
                          token:(NSString *)token
                    requestName:(NSString *)requestName;

/**
 游记详情

 @param noteId 游记id
 @param requestName 请求方法名
 */
-(void)getNoteDetailWithNoteId:(NSString *)noteId
                         token:(NSString *)token
                   requestName:(NSString *)requestName;

/**
 获取游记详情的评论列表

 @param noteId 游记id
 @param offset 限制结果数量
 @param limit 查询条数
 @param requestName 请求方法名
 */
-(void)getNoteDetailCommentsWithNoteId:(NSString *)noteId
                                offset:(NSString *)offset
                                 limit:(NSString *)limit
                                 token:(NSString *)token
                           requestName:(NSString *)requestName;

/**
 获取游记列表

 @param type 查询类型 1、按量排序 2、精选游记 3、我的游记
 @param sort_type 按量排序类型 1、最新时间 2、浏览数 3、评论数 4、收藏数
 @param offset 限制结果数量
 @param limit 查询条数
 @param requestName 请求方法名
 */
-(void)getNoteListWithType:(NSString *)type
                 sort_type:(NSString *)sort_type
                    offset:(NSString *)offset
                     limit:(NSString *)limit
                     token:(NSString *)token
               requestName:(NSString *)requestName;

/**
 收藏游记

 @param noteId 游记id
 @param requestName 请求方法名
 */
-(void)postCollectNoteWithNoteId:(NSString *)noteId
                           token:(NSString *)token
                    requestName:(NSString *)requestName;

/**
 关注用户

 @param about_type 用户类型 1、用户 2、导师
 @param about_id 用户id
 @param requestName 请求方法名
 */
-(void)postFollowWithAboutType:(NSString *)about_type
                       aboutId:(NSString *)about_id
                         token:(NSString *)token
                   requestName:(NSString *)requestName;

/**
 举报

 @param token 登录的token
 @param position 投诉标记 1、游记 2、游记评论 3、游记回复 4、导师评价 5、动态 6、动态评论 7、动态回复 8、其他
 @param content 投诉内容
 @param complaints 投诉人昵称
 @param foreign_id 被投诉的内容
 @param requestName 请求方法名
 */
-(void)getReportWithToken:(NSString *)token
                 position:(NSString *)position
                  content:(NSString *)content
               complaints:(NSString *)complaints
               foreign_id:(NSString *)foreign_id
              requestName:(NSString *)requestName;

/**
 获取回复列表

 @param noteId 游记id
 @param reply_id 评论id
 @param offset 查询u页
 @param limit 查询数
 */
-(void)getNoteReplyListWithNoteID:(NSString *)noteId
                         reply_id:(NSString *)reply_id
                           offset:(NSString *)offset
                            limit:(NSString *)limit
                            token:(NSString *)token
                      requestName:(NSString *)requestName;

/**
 游记点赞

 @param noteId 游记id
 @param type 点赞类型 1、游记 2、评论
 @param replyId 评论id
 @param token token
 @param requestName 请求方法名
 */
-(void)postPraiseNoteWithNoteId:(NSString *)noteId
                           type:(NSString *)type
                        replyId:(NSString *)replyId
                          token:(NSString *)token
                    requestName:(NSString *)requestName;

/**
 发布游记

 @param travels 游记内容
 @param userType 用户类型
 @param token token
 @param requestName 请求方法名
 */
-(void)postSubmitNoteWithTravels:(NSDictionary *)travels
                        userType:(NSString *)userType
                           token:(NSString *)token
                     requestName:(NSString *)requestName;


/**
 发布游记评论

 @param noteId 游记id
 @param replyId 回复id
 @param type 回复类型 1、游记 2、评论
 @param content 回复内容
 @param img 图片
 @param token token
 @param requestName 
 */
-(void)postNoteCommentWithNoteId:(NSString *)noteId
                         replyId:(NSString *)replyId
                            type:(NSString *)type
                         content:(NSString *)content
                             img:(NSString *)img
                           token:(NSString *)token
                     requestName:(NSString *)requestName;

/**
 获取用户详情游记列表

 @param ubid 用户id
 @param offset 分页
 @param limit 数据
 @param requestName 请求方法名
 */
-(void)getUserNoteListWithUbId:(NSString *)ubid
                        offset:(NSString *)offset
                         limit:(NSString *)limit
                   requestName:(NSString *)requestName;

@end

NS_ASSUME_NONNULL_END
