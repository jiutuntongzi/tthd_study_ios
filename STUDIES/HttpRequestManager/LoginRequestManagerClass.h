//
//  LoginRequestManagerClass.h
//  STUDIES
//
//  Created by happyi on 2019/4/3.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "RequestManager.h"

@interface LoginRequestManagerClass : RequestManager

/**
 获取验证码

 @param phoneNumber 手机号码
 @param requestName 请求方法名
 */
-(void)getUserAuthCodeWithPhoneNumber:(NSString *)phoneNumber
                          requestName:(NSString *)requestName;

/**
 手机验证码登录

 @param authCode 验证码
 @param phoneNumber 手机号码
 @param requestName 请求方法名
 */
-(void)getUserLoginWithAuthCode:(NSString *)authCode
                    phoneNumber:(NSString *)phoneNumber
                    requestName:(NSString *)requestName;

/**
 校验验证码与手机

 @param phone 手机号码
 @param code 验证码
 @param event 事件
 @param requestName 请求方法名
 */
-(void)getCheckUserCodeWithPhone:(NSString *)phone
                            code:(NSString *)code
                           event:(NSString *)event
                     requestName:(NSString *)requestName;

/**
 设置密码

 @param phone 手机号码
 @param password 密码
 @param code 验证码
 @param requestName 请求方法名
 */
-(void)getSetUserPwdWithPhone:(NSString *)phone
                     password:(NSString *)password
                         code:(NSString *)code
                  requestName:(NSString *)requestName;

/**
 密码登录

 @param password 密码
 @param phone 手机
 @param requestName 请求方法名
 */
-(void)getUserLoginWthPassword:(NSString *)password
                         phone:(NSString *)phone
                   requestName:(NSString *)requestName;

/**
 修改手机号码

 @param mobile 手机
 @param code 验证码
 @param token token
 */
-(void)getEditUserPhoneWithMobile:(NSString *)mobile
                             code:(NSString *)code
                            token:(NSString *)token
                      requestName:(NSString *)requestName;
@end

