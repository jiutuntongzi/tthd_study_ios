//
//  UserCollectModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/30.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCollectModel : NSObject
/** 收藏id */
@property (nonatomic, strong) NSString *collect_id;
/** 类别 1、游记 2、路线 */
@property (nonatomic, strong) NSString *type;
/** 游记 */
@property (nonatomic, strong) NSDictionary *travels;
/** 路线 */
@property (nonatomic, strong) NSDictionary *path;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

