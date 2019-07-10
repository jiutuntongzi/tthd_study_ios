//
//  TopicDetailModel.h
//  STUDIES
//
//  Created by happyi on 2019/6/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicDetailModel : NSObject

/** 点击数 */
@property (nonatomic, strong) NSString *clicks;
/** 时间 */
@property (nonatomic, strong) NSString *createtime;
/** 内容 */
@property (nonatomic, strong) NSString *describe;
/** 讨论数 */
@property (nonatomic, strong) NSString *discuss;
/** 是否关注 */
@property (nonatomic, strong) NSString *follow;
/** 话题id */
@property (nonatomic, strong) NSString *topicId;
/** 图集 */
@property (nonatomic, strong) NSString *images;
/** 是否热门 */
@property (nonatomic, strong) NSString *is_hot;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 用户id */
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

