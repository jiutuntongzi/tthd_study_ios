//
//  UserInfoModel.h
//  STUDIES
//
//  Created by happyi on 2019/4/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BGFMDB.h>
@interface UserInfoModel : NSObject

/** 头像 */
@property(nonatomic, strong) NSString *avatar;
/** 用户id */
@property(nonatomic, strong) NSString *user_id;
/** 用户名 */
@property(nonatomic, strong) NSString *username;
/** token */
@property(nonatomic, strong) NSString *token;
/** 昵称 */
@property(nonatomic, strong) NSString *nickname;
/** 手机号码 */
@property(nonatomic, strong) NSString *mobile;
/** 简介 */
@property(nonatomic, strong) NSString *bio;
/** 性别 */
@property(nonatomic, strong) NSString *gender;
/** ub_id */
@property(nonatomic, strong) NSString *ub_id;

/**
 model初始化

 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

