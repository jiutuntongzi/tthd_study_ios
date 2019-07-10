//
//  HomeTutorModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeTutorModel : NSObject

/** id */
@property (nonatomic, strong) NSString *tId;
/** 名称 */
@property (nonatomic, strong) NSString *nickname;
/** 用户id */
@property (nonatomic, strong) NSString *ub_id;
/** 评分 */
@property (nonatomic, strong) NSString *star;
/** 头像 */
@property (nonatomic, strong) NSString *avatar;
/** 是否关注 */
@property (nonatomic, strong) NSString *is_follow;
/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

