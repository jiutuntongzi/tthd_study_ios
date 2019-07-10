//
//  LineThemeItemModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineThemeItemModel : NSObject

/** id */
@property (nonatomic, strong) NSString *pId;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 封面 */
@property (nonatomic, strong) NSString *cover_img;
/** 导师id */
@property (nonatomic, strong) NSString *tutor_id;
/** 头像 */
@property (nonatomic, strong) NSString *avatar;
/** 名称 */
@property (nonatomic, strong) NSString *nickname;
/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

