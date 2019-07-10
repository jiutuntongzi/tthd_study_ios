//
//  UserCollectLineModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/30.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCollectLineModel : NSObject
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 封面 */
@property (nonatomic, strong) NSString *cover_img;
/** 是否热门 */
@property (nonatomic, strong) NSString *hot;
/** 导师id */
@property (nonatomic, strong) NSString *tutor_id;
/** 名称 */
@property (nonatomic, strong) NSString *nickname;
/** 头像 */
@property (nonatomic, strong) NSString *avatar;
/**  */
@property (nonatomic, strong) NSString *claim_id;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end


