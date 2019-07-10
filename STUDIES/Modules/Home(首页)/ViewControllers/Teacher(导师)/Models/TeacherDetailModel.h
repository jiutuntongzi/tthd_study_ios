//
//  TeacherDetailModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherDetailModel : NSObject

/** 导师id */
@property (nonatomic, strong) NSString *tutor_id;
/** 用户id */
@property (nonatomic, strong) NSString *ub_id;
/** 等级 */
@property (nonatomic, strong) NSString *star;
/** 名称 */
@property (nonatomic, strong) NSString *nickname;
/** 头像 */
@property (nonatomic, strong) NSString *avatar;
/** 性别 */
@property (nonatomic, strong) NSString *sex;
/** 简介 */
@property (nonatomic, strong) NSString *bio;
/** 类别 */
@property (nonatomic, strong) NSString *type;
/** 关注数 */
@property (nonatomic, strong) NSString *follow_number;
/** 粉丝数 */
@property (nonatomic, strong) NSString *attention_number;
/** 是否关注 */
@property (nonatomic, strong) NSString *is_follow;
/** 介绍 */
@property (nonatomic, strong) NSString *intro;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

