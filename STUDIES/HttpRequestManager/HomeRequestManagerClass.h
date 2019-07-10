//
//  HomeRequestManagerClass.h
//  STUDIES
//
//  Created by happyi on 2019/5/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "RequestManager.h"

@interface HomeRequestManagerClass : RequestManager

/**
 获取首页数据

 @param requestName 请求方法名
 */
-(void)getHomeWithUbId:(NSString *)ubId requestName:(NSString *)requestName;

/**
 首页搜索

 @param key 关键字
 @param token token
 @param type 类别1、话题 2、用户
 @param page 页码
 @param pageSize 数量
 */
-(void)postHomeSearchWithKey:(NSString *)key
                       token:(NSString *)token
                        type:(NSString *)type
                        page:(NSString *)page
                    pageSize:(NSString *)pageSize
                 requestName:(NSString *)requestName;

@end

