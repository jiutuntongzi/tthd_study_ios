//
//  KyoDateTools.h
//  STUDIES
//
//  Created by happyi on 2019/5/23.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KyoDateTools : NSObject

/**
 两个日期相隔

 @param fromDate
 @param toDate
 @return
 */
+ (NSDateComponents *)dateDiff:(NSDate *)fromDate toDate:(NSDate *)toDate;

/**
 日期比较

 @param dateString
 @return
 */
+ (BOOL)compareDate:(NSString *)dateString;

/**
 两个日期比较

 @param oneDate
 @param twoDate
 @return
 */
+ (BOOL)compareDate:(NSDate *)oneDate toDate:(NSDate *)twoDate;

/**
 转成农历x样式

 @param dateString
 @param format
 @param year
 @return
 */
+ (NSString *)formatChineseWithString:(NSString *)dateString format:(NSString *)format isYear:(BOOL)year;

/**
 NSString 转 NSDate

 @param dateString
 @return
 */
+ (NSDate *)convertDateFromString:(NSString *)dateString;

/**
 NSString 转 NSDate

 @param dateString
 @param format
 @return
 */
+ (NSDate *)convertDateFromString:(NSString *)dateString formatter:(NSString *)format;

/**
 *  NSDate 转 NSString
 *
 *  @param date 日期
 *
 *  @return
 */
+ (NSString *)convertStringFromDate:(NSDate *)date;

/**
 *  NSString 转 NSDate
 *
 *  @param dateString 日期字符串，格式：yyyy-MM-dd HH:mm:ss
 *
 *  @return
 */
+ (NSDate *)stringToDate:(NSString *)dateString;

/**
 *  NSDate 转 NSString
 *
 *  @param date
 *
 *  @return
 */
+ (NSString *)dataToString:(NSDate *)date;

/**
 *  获取当前时间
 *
 *  @param timeDifference 时间偏移量
 *
 *  @return
 */
+ (NSDate *)getCurrentDate:(NSInteger)timeDifference;

/**
 *  获取系统当前时间
 *
 *  @return
 */
+ (NSString *)getCurrentTime;

/**
 *  获取系统当前时间
 *
 *  @param formate
 *
 *  @return
 */
+ (NSString *)getCurrentTime:(NSString *)formate;

/**
 *  获取系统当前时间
 *
 *  @return
 */
+ (NSString *)getCurrentDateString;

/**
 *  获取当前时间
 *
 *  @param timeDifference 时间偏移量
 *
 *  @return
 */
+ (NSString *)getCurrentDateString:(NSInteger)timeDifference;

/**
 *  获取当前时间
 *
 *  @param formatter 时间格式
 *
 *  @return
 */
+ (NSString *)getCurrentDateFormatterString:(NSString *)formatter;

/**
 *  获取当前时间
 *
 *  @param timeDifference 时间偏移量
 *  @param formatter      时间格式
 *
 *  @return
 */
+ (NSString *)getCurrentDateString:(NSInteger)timeDifference formatter:(NSString *)formatter;

/**
 *  本机时间与指定时间相差多少秒
 *
 *  @param dateString 日期字符串，格式：yyyy-MM-dd HH:mm:ss
 *
 *  @return
 */
+ (NSInteger)differenceSeconds:(NSString *)dateString;

/**
 *  计算两个日期相隔
 *
 *  @param oneDate 第一个日期
 *  @param twoDate 第二个日期
 *
 *  @return
 */
+ (NSDateComponents *)dateDiff:(NSDate *)oneDate twoDate:(NSDate *)twoDate;


/**
 *  判断是否为同一天
 *
 *  @param dateString1
 *  @param dateString2
 *
 *  @return
 */
+ (BOOL)compareEqual:(NSString *)dateString1 toDate:(NSString *)dateString2;

/**
 *  返回一个漂亮的日期字符串显示
 *
 *  1分钟以内 显示 = 刚刚
 *  1小时以内 显示 = X分钟前
 *  今天或者昨天显示 = 今天 09:30 | 昨天 09:30
 *  今年显示 = 09月12日
 *  大于本年显示 = 2013/09/09
 *
 *  @param dateString
 *
 *  @return
 */
+ (NSString *)prettyDateWithDateString:(NSString *)dateString;

/**
 *  返回一个漂亮的日期字符串显示
 *
 *  1分钟以内 显示 = 刚刚
 *  1小时以内 显示 = X分钟前
 *  今天或者昨天显示 = 今天 09:30 | 昨天 09:30
 *  今年显示 = 09月12日
 *  大于本年显示 = 2013/09/09
 *
 *  @param data
 *
 *  @return
 */
+ (NSString *)prettyDateWithDate:(NSDate *)date;

/**
 *  返回特定的时间格式
 *  若是当天则显示为：上午9:40；
 *  若时间大于1天，则显示为：昨天；；
 *  若时间大于2天，则显示日期为:16-1-2
 *  @param dateString
 *
 *  @return
 */
+ (NSString *)certainDateWithString:(NSString *)dateString;
/**
 *  返回特定的时间格式
 *  若是当天则显示为：上午9:40；
 *  若时间大于1天，则显示为：昨天；；
 *  若时间大于2天，则显示日期为:16-1-2
 *  @param dateString
 *
 *  @return
 */
+ (NSString *)certainDateWithData:(NSDate *)date;
/**
 *  格式化 NSDate
 *
 *  @param date
 *  @param format
 *
 *  @return
 */
+ (NSString *)formatDate:(NSDate *)date format:(NSString *)format;

/**
 *  格式化 NSDate
 *
 *  @param dateString
 *  @param format
 *
 *  @return
 */
+ (NSString *)formatDateString:(NSString *)dateString format:(NSString *)format;

/**
 *  1970 vs 2001 core date数据库数据:2016/03/01 09:21:57  mfdb读出来为 1985/03/01 09:21:57 然后再转为 2016/03/01 09:21:57
 *
 *  @param date1
 *
 *  @return
 */
+ (NSDate *)formatDateSince2011By1970:(NSDate *)date;

/**
 *  比较两个date之间的间隔天数
 *
 *  @param fromDateTime fromDateTime description
 *  @param toDateTime   toDateTime description
 *
 *  @return 
 */
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;


@end

