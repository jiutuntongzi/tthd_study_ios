//
//  HomeTravelModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeTravelModel : NSObject

/** id */
@property (nonatomic, strong) NSString *tId;
/** 用户id */
@property (nonatomic, strong) NSString *ub_id;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 图片集 */
@property (nonatomic, strong) NSArray *imgs;
/** 是否精选 */
@property (nonatomic, strong) NSString *sift;
/** 时间 */
@property (nonatomic, strong) NSString *add_time;
/** 回复数 */
@property (nonatomic, strong) NSString *reply_number;
/** 浏览数 */
@property (nonatomic, strong) NSString *hits;
/** 用户类型 */
@property (nonatomic, strong) NSString *user_type;
/** 名称 */
@property (nonatomic, strong) NSString *nickname;
/** 头像 */
@property (nonatomic, strong) NSString *avatar;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end
