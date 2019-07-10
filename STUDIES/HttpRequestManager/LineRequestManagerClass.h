//
//  LineRequestManagerClass.h
//  STUDIES
//
//  Created by happyi on 2019/5/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineRequestManagerClass : RequestManager

/**
 热门目的地

 @param type 查询类型 1、路线首页 2、目的地查询
 @param requestName 请求方法名
 */
-(void)getHotDestinationWithType:(NSString *)type
                     requestName:(NSString *)requestName;

/**
 当季热门主题

 @param requestName 请求方法名
 */
-(void)getHotThemeWithRequestName:(NSString *)requestName;

/**
 目的地线路查询

 @param dId 目的地id
 @param offset 限制结果数量
 @param limit 查询条数
 @param requestName 请求方法名
 */
-(void)getDestinationLineWithDId:(NSString *)dId
                          offset:(NSString *)offset
                           limit:(NSString *)limit
                     requestName:(NSString *)requestName;

/**
 查询路线详情

 @param lineId 路线id
 @param tutorId 导师id
 @param requestName 请求方法名
 */
-(void)getLineDetailWithLineId:(NSString *)lineId
                       tutorId:(NSString *)tutorId
                         token:(NSString *)token
                   requestName:(NSString *)requestName;

/**
 路线搜索

 @param keyword 关键词
 @param offset 限制结果数量
 @param limit 查询条数
 @param requestName 请求方法名
 */
-(void)getLineSearchWithKeyword:(NSString *)keyword
                         offset:(NSString *)offset
                          limit:(NSString *)limit
                    requestName:(NSString *)requestName;

/**
 收藏路线

 @param lineId 路线id
 @param token token
 @param requestName 请求方法名
 */
-(void)postLineCollectWithLineId:(NSString *)lineId
                           token:(NSString *)token
                     requestName:(NSString *)requestName;

@end

