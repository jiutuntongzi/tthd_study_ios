//
//  TeacherFansOrFollowsModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherFansOrFollowsModel : NSObject
/** 头像 */
@property (nonatomic, strong) NSString *avatar;
/** 简介 */
@property (nonatomic, strong) NSString *bio;
/** 粉丝数 */
@property (nonatomic, strong) NSString *follow_number;
/** 是否关注 */
@property (nonatomic, strong) NSString *is_follow;
/** 名称 */
@property (nonatomic, strong) NSString *nickname;
/** 用户id */
@property (nonatomic, strong) NSString *ub_id;
/** 用户类型 */
@property (nonatomic, strong) NSString *user_type;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

