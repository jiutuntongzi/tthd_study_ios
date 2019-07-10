//
//  TeacherTypeModel.h
//  STUDIES
//
//  Created by happyi on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherTypeModel : NSObject

/** id */
@property (nonatomic, strong) NSString *typeId;
/** 标题 */
@property (nonatomic, strong) NSString *name;

/**
 model初始化
 
 @param dict 字典
 @return self
 */
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end

