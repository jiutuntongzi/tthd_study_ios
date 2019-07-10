//
//  CommonRequestManagerClass.h
//  STUDIES
//
//  Created by happyi on 2019/5/27.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "RequestManager.h"

@interface CommonRequestManagerClass : RequestManager

/**
 获取首页banner
 
 @param position banner位置
 @param requestName 请求方法名
 */
-(void)getBannerWithPosition:(NSString *)position
                 requestName:(NSString *)requestName;


/**
 上传图片
 
 @param images 图片集
 @param fileNames 文件名
 @param requestName 请求方法名
 */
-(void)uploadImages:(NSArray <UIImage *> *)images
             fileNames:(NSArray <NSString *> *)fileNames
           requestName:(NSString *)requestName;

/**
 投诉举报

 @param position 投诉位置 1、游记 2、游记评论 3、游记回复 4、导师评价 5、动态 6、动态评论 7、动态回复 8、其他
 @param content 投诉内容
 @param complaints 投诉人昵称
 @param foreignId 被投诉的内容
 @param token token
 @param requestName 请求方法名
 */
-(void)getReportWithPosition:(NSString *)position
                     content:(NSString *)content
                  complaints:(NSString *)complaints
                   foreignId:(NSString *)foreignId
                       token:(NSString *)token
                 requestName:(NSString *)requestName;

@end

