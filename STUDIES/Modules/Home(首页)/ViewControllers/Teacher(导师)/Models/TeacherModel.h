//
//  TeacherModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherModel : NSObject

/** 头像 */
@property (nonatomic, strong) NSString *avatar;
/** 简介 */
@property (nonatomic, strong) NSString *bio;
/** 是否关注 */
@property (nonatomic, strong) NSString *is_follow;
/** 名称 */
@property (nonatomic, strong) NSString *nickname;
/** 性别 */
@property (nonatomic, strong) NSString *sex;
/** 星级 */
@property (nonatomic, strong) NSString *star;
/** 导师id */
@property (nonatomic, strong) NSString *tutor_id;
/** 用户id */
@property (nonatomic, strong) NSString *ub_id;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

