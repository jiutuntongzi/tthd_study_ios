//
//  MyTools.h
//  STUDIES
//
//  Created by happyi on 2019/3/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

//设备机型
typedef NS_ENUM(NSInteger, PhoneType) {
    PhoneType_Screen_FULL,      //全面屏
    PhoneType_Screen_NORMAL     //普通
};

@interface MyTools : NSObject

//获取当前设备机型
+(PhoneType)getPhoneType;

//初始化label
+(QMUILabel *)labelWithText:(NSString *)text
                textColor:(UIColor *)textColor
                 textFont:(UIFont *)textFont
            textAlignment:(NSTextAlignment)textAlignment;

/**
 时间戳转换时间

 @param stampString 时间戳
 @return 时间
 */
+(NSString *)getDateStringWithTimeInterval:(NSString *)stampString;

/**
 获取用户的token

 @return token
 */
+(NSString *)userToken;


/**
 动态发布时参数转码

 @param string
 @return
 */
+(NSString *)utf8ToUnicode:(NSString *)string;

+(NSString *)unicodeToString:(NSString *)unicodeStr;

@end

