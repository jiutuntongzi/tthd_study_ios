//
//  NoteSearchModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/20.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NoteSearchModel : NSObject

/** 用户id */
@property (nonatomic, strong) NSString *ub_id;
/** 名称 */
@property (nonatomic, strong) NSString *title;
/** 图集 */
@property (nonatomic, strong) NSArray *imgs;
/** 是否精选 */
@property (nonatomic, strong) NSString *sift;
/** 发布时间 */
@property (nonatomic, strong) NSString *add_time;
/** 收藏数 */
@property (nonatomic, strong) NSString *collect_number;
/** 点赞数 */
@property (nonatomic, strong) NSString *live_number;
/** 用户名 */
@property (nonatomic, strong) NSString *nickname;
/** 头像 */
@property (nonatomic, strong) NSString *avatar;
/** 游记id */
@property (nonatomic, strong) NSString *noteId;
/** 是否收藏 */
@property (nonatomic, strong) NSString *is_collect;
/** 是否点赞 */
@property (nonatomic, strong) NSString *is_live;
/** 用户类别 1、用户 2、导师 */
@property (nonatomic, strong) NSString *user_type;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

