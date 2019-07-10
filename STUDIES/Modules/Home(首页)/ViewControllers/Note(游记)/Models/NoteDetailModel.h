//
//  NoteDetailModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/20.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteDetailModel : NSObject

/** 游记id */
@property(nonatomic, strong) NSString *noteId;
/** 用户id */
@property(nonatomic, strong) NSString *ub_id;
/** 标题 */
@property(nonatomic, strong) NSString *title;
/** 图集 */
@property(nonatomic, strong) NSArray *imgs;
/** 内容 */
@property(nonatomic, strong) NSString *content;
/** 时间 */
@property(nonatomic, strong) NSString *add_time;
/** 收藏数 */
@property(nonatomic, strong) NSString *collect_number;
/** 点赞数 */
@property(nonatomic, strong) NSString *live_number;
/** 回复数 */
@property(nonatomic, strong) NSString *reply_number;
/** 姓名 */
@property(nonatomic, strong) NSString *nickname;
/** 头像 */
@property(nonatomic, strong) NSString *avatar;
/** 是否收藏 */
@property(nonatomic, strong) NSString *is_collect;
/** 是否点赞 */
@property(nonatomic, strong) NSString *is_live;
/** 是否关注 */
@property(nonatomic, strong) NSString *is_follow;
/** 用户类型 1、用户 2、导师 */
@property(nonatomic, strong) NSString *user_type;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end
