//
//  TeacherEvaluateModel.h
//  STUDIES
//
//  Created by 花想容 on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherEvaluateModel : NSObject
/** 评价id */
@property (nonatomic, strong) NSString *evaluateId;
/** 导师id */
@property (nonatomic, strong) NSString *tutor_id;
/** 星级 */
@property (nonatomic, strong) NSString *star;
/** 评价内容 */
@property (nonatomic, strong) NSString *evaluate;
/** 用户id */
@property (nonatomic, strong) NSString *ub_id;
/** 图集 */
@property (nonatomic, strong) NSArray *images;
/** 评价时间 */
@property (nonatomic, strong) NSString *createtime;
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

