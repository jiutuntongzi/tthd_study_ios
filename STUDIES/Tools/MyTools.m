//
//  MyTools.m
//  STUDIES
//
//  Created by happyi on 2019/3/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MyTools.h"
#import <sys/utsname.h>

@implementation MyTools

#pragma mark - 获取设备类型
+(PhoneType)getPhoneType
{
    if (SCREEN_HEIGHT > 800) {
        return PhoneType_Screen_FULL;
    }
    return PhoneType_Screen_NORMAL;
}

#pragma mark - 初始化label
+(QMUILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor textFont:(UIFont *)textFont textAlignment:(NSTextAlignment)textAlignment
{
    QMUILabel *label = [QMUILabel new];
    label.text = text;
    label.textColor = textColor;
    label.font = textFont;
    label.textAlignment = textAlignment;
    
    return label;
}

#pragma mark - 时间戳转换
+(NSString *)getDateStringWithTimeInterval:(NSString *)stampString
{
    NSString *timeStampString  = stampString;
    NSTimeInterval interval    =[timeStampString doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    
    return dateString;
}

#pragma mark - 获取用户的token
+(NSString *)userToken
{
    NSString *token;
    if ([UserInfoModel bg_findAll:T_USERINFO].count > 0) {
        token = [[UserInfoModel bg_findAll:T_USERINFO][0] token];
    }else{
        token = nil;
    }
    
    return token;
}

#pragma mark - 字符串转码
+ (NSString *)utf8ToUnicode:(NSString *)string
{
    NSUInteger length = [string length];
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++){
        NSMutableString *s = [NSMutableString stringWithCapacity:0];
        unichar _char = [string characterAtIndex:i];
        
        if (_char == '<' || _char == '>') {
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
            // 不足位数补0 否则解码不成功
            if(s.length == 4) {
                [s insertString:@"00" atIndex:2];
            } else if (s.length == 5) {
                [s insertString:@"0" atIndex:2];
            }
        }else{
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }
        
        [str appendFormat:@"%@", s];
    }
    return str;
}

+(NSString *)unicodeToString:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    
    
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\r\n"withString:@"\n"];
    
}

@end
