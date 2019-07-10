//
//  DynamicPraiseModel.h
//  STUDIES
//
//  Created by happyi on 2019/6/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicPraiseModel : NSObject

/** 头像 */
@property (nonatomic, strong) NSString *avatar;
/** 头像 */
@property (nonatomic, strong) NSString *createtime ;
/** 头像 */
@property (nonatomic, strong) NSString *nickname;
/** 头像 */
@property (nonatomic, strong) NSString *ub_id;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

