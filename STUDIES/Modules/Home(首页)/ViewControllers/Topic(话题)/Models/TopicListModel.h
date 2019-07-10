//
//  TopicListModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicListModel : NSObject

/** 话题id */
@property (nonatomic, strong) NSString *topicId;
/** 用户id */
@property (nonatomic, strong) NSString *ub_id;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 内容 */
@property (nonatomic, strong) NSString *describe;
/** 是否热门 */
@property (nonatomic, strong) NSString *is_hot;
/** 点击数 */
@property (nonatomic, strong) NSString *clicks;
/** 讨论数 */
@property (nonatomic, strong) NSString *discuss;
/** 图集 */
@property (nonatomic, strong) NSString *images;
/** 时间 */
@property (nonatomic, strong) NSString *createtime;
/** 用户 */
@property (nonatomic, strong) NSDictionary *user;
/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

