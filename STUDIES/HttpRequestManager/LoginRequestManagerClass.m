//
//  LoginRequestManagerClass.m
//  STUDIES
//
//  Created by happyi on 2019/4/3.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LoginRequestManagerClass.h"

@implementation LoginRequestManagerClass

#pragma mark - 获取验证码
-(void)getUserAuthCodeWithPhoneNumber:(NSString *)phoneNumber requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:phoneNumber, @"mobile", nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_GETWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            [self.delegate requestSuccess:nil requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 手机验证码登录
-(void)getUserLoginWithAuthCode:(NSString *)authCode phoneNumber:(NSString *)phoneNumber requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      phoneNumber, @"mobile",
                                      authCode, @"captcha",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_GETWithEntity:entity successBlock:^(id response) {
        
        if ([response[@"code"] intValue] == 1) {
            [self.delegate requestSuccess:response[@"data"][@"userinfo"] requestName:requestName];
        }else{
            [self.delegate requestFailure:nil requestName:requestName];
        }
        
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:error requestName:requestName];

    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 校验验证码
-(void)getCheckUserCodeWithPhone:(NSString *)phone code:(NSString *)code event:(NSString *)event requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      phone, @"mobile",
                                      code, @"captcha",
                                      event, @"event",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_GETWithEntity:entity successBlock:^(id response) {
        
        if ([response[@"code"] intValue] == 1) {
            [self.delegate requestSuccess:nil requestName:requestName];
        }
        
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:error requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 设置密码
-(void)getSetUserPwdWithPhone:(NSString *)phone password:(NSString *)password code:(NSString *)code requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      phone, @"mobile",
                                      code, @"captcha",
                                      password, @"newpassword",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_GETWithEntity:entity successBlock:^(id response) {
        
        if ([response[@"code"] intValue] == 1) {
            [self.delegate requestSuccess:nil requestName:requestName];
        }
        
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:error requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 密码登录
-(void)getUserLoginWthPassword:(NSString *)password phone:(NSString *)phone requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      phone, @"account",
                                      password, @"password",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_GETWithEntity:entity successBlock:^(id response) {
        
        if ([response[@"code"] intValue] == 1) {
            [self.delegate requestSuccess:response[@"data"][@"userinfo"] requestName:requestName];
        }else{
            [self.delegate requestFailure:nil requestName:requestName];
        }
        
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:error requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 修改手机
-(void)getEditUserPhoneWithMobile:(NSString *)mobile code:(NSString *)code token:(NSString *)token requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      mobile, @"mobile",
                                      code, @"captcha",
                                      token, @"token",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_GETWithEntity:entity successBlock:^(id response) {
        
        if ([response[@"code"] intValue] == 1) {
            [self.delegate requestSuccess:response[@"data"] requestName:requestName];
        }else{
            [self.delegate requestFailure:response[@"msg"] requestName:requestName];
        }
        
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:error requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

@end
