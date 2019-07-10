//
//  HomeUserModel.h
//  STUDIES
//
//  Created by happyi on 2019/6/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeUserModel : NSObject

/** 用户id */
@property (nonatomic, strong) NSString *userId;
/** ub_id */
@property (nonatomic, strong) NSString *ub_id;
/** username */
@property (nonatomic, strong) NSString *username;
/** 用户名 */
@property (nonatomic, strong) NSString *nickname;
/** 手机 */
@property (nonatomic, strong) NSString *mobile;
/** 头像 */
@property (nonatomic, strong) NSString *avatar;
/** 性别 */
@property (nonatomic, strong) NSString *gender;
/** 介绍 */
@property (nonatomic, strong) NSString *bio;
/** 关注数 */
@property (nonatomic, strong) NSString *follow_count;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

