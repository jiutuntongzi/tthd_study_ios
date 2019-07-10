//
//  LineDestinationModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineDestinationModel : NSObject

/** id */
@property (nonatomic, strong) NSString *dId;
/** 标题 */
@property (nonatomic, strong) NSString *name;
/** 图片 */
@property (nonatomic, strong) NSString *img;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

