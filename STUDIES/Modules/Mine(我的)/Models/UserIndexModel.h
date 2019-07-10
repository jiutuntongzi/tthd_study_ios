//
//  UserIndexModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/31.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserIndexModel : NSObject
/** 粉丝数 */
@property (nonatomic, strong) NSString *attention_number;
/** 头像 */
@property (nonatomic, strong) NSString *avatar;
/** 简介 */
@property (nonatomic, strong) NSString *bio;
/** 动态数 */
@property (nonatomic, strong) NSString *dynamic_number;
/** 关注数 */
@property (nonatomic, strong) NSString *follow_number;
/** 性别 */
@property (nonatomic, strong) NSString *gender;
/** 昵称 */
@property (nonatomic, strong) NSString *nickname;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

