//
//  HomePathModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePathModel : NSObject

/** id */
@property (nonatomic, strong) NSString *pId;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 封面 */
@property (nonatomic, strong) NSString *cover_img;
/** 头像 */
@property (nonatomic, strong) NSString *avatar;
/** 导师id */
@property (nonatomic, strong) NSString *tutor_id;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

