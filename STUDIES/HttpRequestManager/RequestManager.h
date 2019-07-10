//
//  RequestManager.h
//  STUDIES
//
//  Created by happyi on 2019/4/3.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestManagerDelegate <NSObject>

@optional

/**
 请求成功
 
 @param info    回调数据
 @param requestName 方法名
 */
-(void)requestSuccess:(id)info requestName:(NSString *)requestName;

@optional
/**
 请求失败
 
 @param info    回调数据
 @param requestName 方法名
 */
-(void)requestFailure:(id)info requestName:(NSString *)requestName;

@end

@interface RequestManager : NSObject

/**
 代理
 */
@property(nonatomic, weak) id<RequestManagerDelegate>delegate;

/**
 基本参数
 */
@property(nonatomic, strong) NSDictionary *baseParameter;

@end

