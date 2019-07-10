//
//  DynamicListModel.h
//  STUDIES
//
//  Created by 花想容 on 2019/6/1.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicListModel : NSObject
/** 评论数 */
@property (nonatomic, strong) NSString *comments;
/** 内容 */
@property (nonatomic, strong) NSString *content;
/** 时间 */
@property (nonatomic, strong) NSString *createtime;
/** 点赞数 */
@property (nonatomic, strong) NSString *forwardings;
/** id */
@property (nonatomic, strong) NSString *dynamicId;
/** 图集 */
@property (nonatomic, strong) NSString *images;
/** 是否删除 */
@property (nonatomic, strong) NSString *is_delete;
/** 是否关注 */
@property (nonatomic, strong) NSString *is_follow;
/** 评论数 */
@property (nonatomic, strong) NSString *likes;
/** 位置 */
@property (nonatomic, strong) NSString *position;
/** 话题 */
@property (nonatomic, strong) NSArray *topics;
/** 游记 */
@property (nonatomic, strong) NSDictionary *travel;
/** 游记id */
@property (nonatomic, strong) NSString *travel_id;
/** ubid */
@property (nonatomic, strong) NSString *ub_id;
/** 用户 */
@property (nonatomic, strong) NSDictionary *user;
/** 视频 */
@property (nonatomic, strong) NSString *video;
/** 是否点赞 */
@property (nonatomic, strong) NSString *is_likes;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;
@end

