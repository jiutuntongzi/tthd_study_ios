//
//  HomeCallModel.h
//  STUDIES
//
//  Created by happyi on 2019/6/11.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeCallModel : NSObject

/** 图片 */
@property (nonatomic, strong) NSString *cover_img;
/** 链接 */
@property (nonatomic, strong) NSString *url;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

