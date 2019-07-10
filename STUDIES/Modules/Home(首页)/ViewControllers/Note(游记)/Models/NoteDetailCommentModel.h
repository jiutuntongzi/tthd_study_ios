//
//  NoteDetailCommentModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/22.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteDetailCommentModel : NSObject

/** 头像 */
@property (nonatomic, strong) NSString *avatar;
/** 内容 */
@property (nonatomic, strong) NSString *content;
/** 时间 */
@property (nonatomic, strong) NSString *create_time;
/** 评论id */
@property (nonatomic, strong) NSString *commentID;
/** 图片 */
@property (nonatomic, strong) NSString *img;
/** 是否点赞 */
@property (nonatomic, strong) NSString *is_live;
/** 点赞数 */
@property (nonatomic, strong) NSString *live_number;
/** 名称 */
@property (nonatomic, strong) NSString *nickname;
/** 回复的名称 */
@property (nonatomic, strong) NSString *reply_nickname;
/** 回复的数量 */
@property (nonatomic, strong) NSString *reply_number;
/** 用户id */
@property (nonatomic, strong) NSString *ub_id;
/** 是否关注 */
@property (nonatomic, strong) NSString *is_follow;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

