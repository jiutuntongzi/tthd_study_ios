//
//  TeacherRequestManagerClass.h
//  STUDIES
//
//  Created by happyi on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "RequestManager.h"

@interface TeacherRequestManagerClass : RequestManager

/**
 获取导师分类

 @param requestName 请求方法名
 */
-(void)getTeacherTypeWithRequestName:(NSString *)requestName;

/**
 获取分类导师列表

 @param type 查询类型 1、分类查询 2、星级查询
 @param userType 用户类型 1、用户 2、导师
 @param labelType 分类查询类型 默认为0 0、全部分类
 @param offset 限制结果数量
 @param limit 查询条数
 */
-(void)getTeacherListWithType:(NSString *)type
                     userType:(NSString *)userType
                    labelType:(NSString *)labelType
                       offset:(NSString *)offset
                        limit:(NSString *)limit
                        token:(NSString *)token
                  requestName:(NSString *)requestName;

/**
 导师搜索

 @param keyword 关键词
 @param offset 限制结果数量
 @param limit 查询条数
 @param requestName 请求方法名
 */
-(void)getTeacherSearchWithKeyword:(NSString *)keyword
                            offset:(NSString *)offset
                             limit:(NSString *)limit
                             token:(NSString *)token
                       requestName:(NSString *)requestName;

/**
 导师详情

 @param teacherId 导师id
 @param userType 用户类型 1、用户 2、导师
 @param requestName 请求方法名
 */
-(void)getTeacherDetailWithTeacherId:(NSString *)teacherId
                            userType:(NSString *)userType
                           aboutType:(NSString *)aboutType
                               token:(NSString *)token
                         requestName:(NSString *)requestName;

/**
 导师路线

 @param teacherId 导师id
 @param offset 限制结果数量
 @param limit 查询条数
 @param requestName 请求方法名
 */
-(void)getTeacherLineWithUbId:(NSString *)ubId
                            offset:(NSString *)offset
                             limit:(NSString *)limit
                       requestName:(NSString *)requestName;

/**
 获取导师评价

 @param teacherId 导师id
 @param offset c限制查询结果
 @param limit 查询条数
 @param requestName 请求方法名
 */
-(void)getTeacherEvaluateWithUbId:(NSString *)ubId
                                offset:(NSString *)offset
                                 limit:(NSString *)limit
                           requestName:(NSString *)requestName;

/**
 获取导师的关注或粉丝

 @param type 类型 1、关注  2、粉丝
 @param aboutId 用户（导师）
 @param aboutType 用户（导师）
 @param userType 此用户类型
 @param offset 限制结果数量
 @param limit 查询条数
 @param requestName 请求方法名
 */
-(void)getTeacherFansOrFollowsWithType:(NSString *)type
                               aboutId:(NSString *)aboutId
                             aboutType:(NSString *)aboutType
                              userType:(NSString *)userType
                                offset:(NSString *)offset
                                 limit:(NSString *)limit
                                 token:(NSString *)token
                           requestName:(NSString *)requestName;

/**
 关注用户或导师

 @param aboutType 关注类型 1：用户 2：导师
 @param userType 用户类型 1、用户 2、导师
 @param aboutId 关注者ub_id
 @param token token
 @param requestName 请求方法名
 */
-(void)postFollowTeacherWithAboutType:(NSString *)aboutType
                             userType:(NSString *)userType
                              aboutId:(NSString *)aboutId
                                token:(NSString *)token
                          requestName:(NSString *)requestName;

/**
 发布导师评价

 @param evaluate 评价
 @param token token
 @param requestName 请求方法名
 */
-(void)postEvaluateTeacherWithEvaluate:(NSDictionary *)evaluate
                                 token:(NSString *)token
                           requestName:(NSString *)requestName;
@end

