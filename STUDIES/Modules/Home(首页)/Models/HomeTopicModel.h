//
//  HomeTopicModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeTopicModel : NSObject

/** id */
@property (nonatomic, strong) NSString *tId;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 是否热门 */
@property (nonatomic, strong) NSString *is_hot_text;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

