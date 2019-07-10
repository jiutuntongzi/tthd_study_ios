//
//  UserReqeustManagerClass.h
//  STUDIES
//
//  Created by happyi on 2019/5/30.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "RequestManager.h"

@interface UserReqeustManagerClass : RequestManager

/**
 获取用户的收藏夹

 @param offset 限制查询数量
 @param limit 查询数量
 @param requestName 请求方法名
 */
-(void)getUserCollectWithOffset:(NSString *)offset
                          limit:(NSString *)limit
                          token:(NSString *)token
                    requestName:(NSString *)requestName;

/**
 修改用户信息

 @param avatar 头像
 @param username 用户名
 @param nickname 昵称
 @param bio 简介
 @param password 密码
 @param gender 性别
 @param token token
 @param requestName 请求方法名
 */
-(void)postUserInfoWithAvatar:(NSString *)avatar
                     username:(NSString *)username
                     nickname:(NSString *)nickname
                          bio:(NSString *)bio
                     password:(NSString *)password
                       gender:(NSString *)gender
                        token:(NSString *)token
                  requestName:(NSString *)requestName;

/**
 获取用户首页信息

 @param token token
 @param requestName 请求方法名
 */
-(void)getUserIndexWithToken:(NSString *)token
                 requestName:(NSString *)requestName;



@end

