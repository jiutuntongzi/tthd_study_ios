//
//  LineDetailModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/27.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineDetailModel : NSObject

/** 路线id */
@property (nonatomic, strong) NSString *lineId;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 目的地id */
@property (nonatomic, strong) NSString *bourn_id;
/** 是否热门 */
@property (nonatomic, strong) NSString *hot;
/** 图集 */
@property (nonatomic, strong) NSArray *imgs;
/** 介绍 */
@property (nonatomic, strong) NSString *intro;
/** 须知 */
@property (nonatomic, strong) NSString *notice;
/** 浏览数 */
@property (nonatomic, strong) NSString *hits;
/** 导师id */
@property (nonatomic, strong) NSString *tutor_id;
/** 头像 */
@property (nonatomic, strong) NSString *avatar;
/** 名称 */
@property (nonatomic, strong) NSString *nickname;
/** 性别 */
@property (nonatomic, strong) NSString *sex;
/** 简介 */
@property (nonatomic, strong) NSString *bio;
/** 评分 */
@property (nonatomic, strong) NSString *star;
/** 是否收藏 */
@property (nonatomic, strong) NSString *is_collect;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

