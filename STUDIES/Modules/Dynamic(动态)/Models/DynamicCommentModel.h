//
//  DyanmicCommentModel.h
//  STUDIES
//
//  Created by happyi on 2019/6/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicCommentModel : NSObject
/** 内容 */
@property (nonatomic, strong) NSString *content;
/** 图片 */
@property (nonatomic, strong) NSString *content_images;
/** 时间 */
@property (nonatomic, strong) NSString *create_time;
/** 动态id */
@property (nonatomic, strong) NSString *dynamic_id;
/** 评论id */
@property (nonatomic, strong) NSString *commentId;
/** 是否点赞 */
@property (nonatomic, strong) NSString *is_like;
/** 点赞数 */
@property (nonatomic, strong) NSString *likes;
/** 回复内容 */
@property (nonatomic, strong) NSDictionary *reply;
/** ubid */
@property (nonatomic, strong) NSString *ub_id;
/** 用户 */
@property (nonatomic, strong) NSDictionary *user;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

