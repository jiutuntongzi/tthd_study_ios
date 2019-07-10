//
//  NoteListModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/23.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteListModel : NSObject

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
/** 用户名 */
@property (nonatomic, strong) NSString *nickname;
/** 头像 */
@property (nonatomic, strong) NSString *avatar;
/** 游记id */
@property (nonatomic, strong) NSString *noteId;
/** 用户类别 1、用户 2、导师 */
@property (nonatomic, strong) NSString *user_type;
/** 回复数量 */
@property (nonatomic, strong) NSString *reply_number;
/** 点击数 */
@property (nonatomic, strong) NSString *hits;


/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

