//
//  BannerModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/23.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject

/** id */
@property (nonatomic, strong) NSString *bannerId;
/** 名称 */
@property (nonatomic, strong) NSString *title;
/** 位置 */
@property (nonatomic, strong) NSString *position;
/** 图片地址 */
@property (nonatomic, strong) NSString *image;
/** 指向链接 */
@property (nonatomic, strong) NSString *url;
/** 时间 */
@property (nonatomic, strong) NSString *createtime;
/** 描述 */
@property (nonatomic, strong) NSString *position_text;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

