//
//  UserModel.h
//  STUDIES
//
//  Created by happyi on 2019/6/5.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

/** 头像 */
@property(nonatomic, strong) NSString *avatar;
/** 简介 */
@property(nonatomic, strong) NSString *bio;
/** 关注数 */
@property(nonatomic, strong) NSString *follow_number;
/** 是否关注 */
@property(nonatomic, strong) NSString *is_follow;
/** 昵称 */
@property(nonatomic, strong) NSString *nickname;
/** ub_id */
@property(nonatomic, strong) NSString *ub_id;
/** 用户类型 1、普通用户 2、导师 */
@property(nonatomic, strong) NSString *user_type;
/** 导师id */
@property(nonatomic, strong) NSString *tutor_id;


/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

