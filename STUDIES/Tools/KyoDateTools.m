//
//  KyoDateTools.m
//  STUDIES
//
//  Created by happyi on 2019/5/23.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "KyoDateTools.h"

@implementation KyoDateTools

/**
 *  两个日期相隔
 *
 *  @param fromDate
 *  @param toDate
 *
 *  @return
 */
+ (NSDateComponents *)dateDiff:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *compInfo = [sysCalendar components:unitFlags fromDate:fromDate toDate:toDate options:0];
    return compInfo;
}

/**
 *  日期比较
 *
 *  @param dateString
 *
 *  @return
 */
+ (BOOL)compareDate:(NSString *)dateString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date1 = [NSDate date];
    NSDate *date2 = [df dateFromString:dateString];
    BOOL show;
    
    switch ([date1 compare:date2]) {
        case NSOrderedSame: {
            // 相等
            show = NO;
            break;
        }
        case NSOrderedAscending: {
            // date1比date2小
            show = NO;
            break;
        }
        case NSOrderedDescending: {
            // date1比date2大
            show = YES;
            break;
        }
        default: {
            // 非法时间
            show = NO;
            break;
        }
    }
    return show;
}

/**
 *  转成农历的样式  2015-04-17 16:24:38 -> 2015年4月17日 16:24 | 4月17日(yes)
 *
 *  @param dateString
 *  @param format
 *  @param year
 *
 *  @return
 */
+ (NSString *)formatChineseWithString:(NSString *)dateString format:(NSString *)format isYear:(BOOL)year {
    // 实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    // string to date
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    if (year) {
        NSMutableString *timeString = [NSMutableString string];
        [timeString appendString:[NSString stringWithFormat:@"%@年%@月%@日 ", @([components year]), @([components month]), @([components day])]];
        [timeString appendString:[NSString stringWithFormat:@"%@%@:", ([components hour] < 10) ? @"0" : @"", @([components hour])]];
        [timeString appendString:[NSString stringWithFormat:@"%@%@", ([components minute] < 10) ? @"0" : @"", @([components minute])]];
        return timeString;
    }
    return [NSString stringWithFormat:@"%@月%@日", @([components month]), @([components day])];
}


/**
 *  NSString 转 NSDate
 *
 *  @param dateString 日期字符串
 *
 *  @return
 */
+ (NSDate *)convertDateFromString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:dateString];
}

/**
 *  NSString 转 NSDate
 *
 *  @param dateString 日期字符串
 *  @param format     格式
 *
 *  @return
 */
+ (NSDate *)convertDateFromString:(NSString *)dateString formatter:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

/**
 *  NSDate 转 NSString
 *
 *  @param date 日期
 *
 *  @return
 */
+ (NSString *)convertStringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}


/**
 *  NSString 转 NSDate
 *
 *  @param dateString 日期字符串，格式：yyyy-MM-dd HH:mm:ss
 *
 *  @return
 */
+ (NSDate *)stringToDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter dateFromString:dateString];
}

/**
 *  NSDate 转 NSString
 *
 *  @param date
 *
 *  @return
 */
+ (NSString *)dataToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:date];
}

/**
 *  获取当前时间
 *
 *  @param timeDifference 时间偏移量
 *
 *  @return
 */
+ (NSDate *)getCurrentDate:(NSInteger)timeDifference {
    NSDate *currentDate = [NSDate date];
    currentDate = [currentDate dateByAddingTimeInterval:timeDifference];
    
    return currentDate;
}

/**
 *  获取系统当前时间
 *
 *  @return
 */
+ (NSString *)getCurrentDateString {
    return [self getCurrentDateString:0];
}

/**
 *  获取当前时间
 *
 *  @param timeDifference 时间偏移量
 *
 *  @return
 */
+ (NSString *)getCurrentDateString:(NSInteger)timeDifference {
    return [self getCurrentDateString:timeDifference formatter:@"yyyy-MM-dd HH:mm:ss"];
}


/**
 *  获取系统当前时间
 *
 *  @return
 */
+ (NSString *)getCurrentTime {
    return [self getCurrentTime:@"yyyy-MM-dd HH:mm:ss"];
}

/**
 *  获取系统当前时间
 *
 *  @param formate
 *
 *  @return
 */
+ (NSString *)getCurrentTime:(NSString *)formate {
    static NSDateFormatter *dateFormatter;
    dateFormatter = dateFormatter ?: [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    NSString *dateTime = [dateFormatter stringFromDate:[NSDate date]];
    return dateTime;
}

/**
 *  获取当前时间
 *
 *  @param formatter 时间格式
 *
 *  @return
 */
+ (NSString *)getCurrentDateFormatterString:(NSString *)formatter {
    return [self getCurrentDateString:0 formatter:formatter];
}

/**
 *  获取当前时间
 *
 *  @param timeDifference 时间偏移量
 *  @param formatter      时间格式
 *
 *  @return
 */
+ (NSString *)getCurrentDateString:(NSInteger)timeDifference formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    
    NSDate *currentDate = [NSDate date];
    currentDate = [currentDate dateByAddingTimeInterval:timeDifference];
    
    return [dateFormatter stringFromDate:currentDate];
}

/**
 *  本机时间与指定时间相差多少秒
 *
 *  @param dateString 日期字符串，格式：yyyy-MM-dd HH:mm:ss
 *
 *  @return
 */
+ (NSInteger)differenceSeconds:(NSString *)dateString {
    // 日期格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 系统时区
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    
    // 传入日期转本系统时区
    NSDate *tempDate = [dateFormatter dateFromString:dateString];
    // 得到传入日期与世界标准时间的偏移量
    NSInteger tempInterval = [timeZone secondsFromGMTForDate:tempDate];
    // 增加偏移量
    NSDate *fromDate = [tempDate dateByAddingTimeInterval:tempInterval];
    
    // 获取当前系统日期
    NSDate *currentDate = [NSDate date];
    // 得到当前系统日期与世界标准时间的偏移量
    NSInteger currentInterval = [timeZone secondsFromGMTForDate:currentDate];
    // 增加偏移量
    NSDate *localeDate = [currentDate dateByAddingTimeInterval:currentInterval];
    
    // 返回间隔
    return [fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
}

/**
 *  计算两个日期相隔
 *
 *  @param oneDate 第一个日期
 *  @param twoDate 第二个日期
 *
 *  @return
 */
+ (NSDateComponents *)dateDiff:(NSDate *)oneDate twoDate:(NSDate *)twoDate {
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [sysCalendar components:unitFlags fromDate:oneDate toDate:twoDate options:0];
}

/**
 *  比较第一个日期是否大于第二个日期
 *
 *  @param oneDate 第一个日期
 *  @param twoDate 第二个日期
 *
 *  @return
 */
+ (BOOL)compareDate:(NSDate *)oneDate toDate:(NSDate *)twoDate {
    BOOL show;
    
    switch ([oneDate compare:twoDate]) {
        case NSOrderedSame: {
            // 相等
            show = NO;
            break;
        }
        case NSOrderedAscending: {
            // oneDate 比 twoDate 小
            show = NO;
            break;
        }
        case NSOrderedDescending: {
            // oneDate 比 twoDate 大
            show = YES;
            break;
        }
        default: {
            // 非法时间
            show = NO;
            break;
        }
    }
    
    return show;
}

/**
 *  判断是否为同一天
 *
 *  @param dateString1
 *  @param dateString2
 *
 *  @return
 */
+ (BOOL)compareEqual:(NSString *)dateString1 toDate:(NSString *)dateString2 {
    // 实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 将需要转换的时间转换成 NSDate 对象
    NSDate *dateString1FormatDate = [dateFormatter dateFromString:dateString1];
    NSDate *dateString2FormatDate = [dateFormatter dateFromString:dateString2];
    
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSString *date1_yMd = [dateFormatter stringFromDate:dateString1FormatDate];
    NSString *date2_yMd = [dateFormatter stringFromDate:dateString2FormatDate];
    
    if ([date1_yMd isEqualToString:date2_yMd]) {
        // 同一天
        return YES;
    } else {
        return NO;
    }
}

/**
 *  返回一个漂亮的日期字符串显示
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
+ (NSString *)prettyDateWithDateString:(NSString *)dateString {
    return [self prettyDateWithDate:[self stringToDate:dateString]];
}

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
+ (NSString *)prettyDateWithDate:(NSDate *)date {
    @try {
        // 日期格式
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *nowDate = [NSDate date];
        // 将需要转换的时间转换成 NSDate 对象
        NSDate *needFormatDate = date;
        // 取当前时间和转换时间两个日期对象的时间间隔
        // 这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        // 再然后，把间隔的秒数折算成天数和小时数：
        NSString *dateStr = @"";
        
        if (time <= 60) {
            // 1分钟以内的
            dateStr = @"刚刚";
        } else if (time <= 60 * 60) {
            // 一个小时以内的
            int mins = time / 60;
            dateStr = [NSString stringWithFormat:@"%d分钟前", mins];
        } else if (time <= 60 * 60 * 24) {
            // 在两天内的
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString *need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                // 在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@", [dateFormatter stringFromDate:needFormatDate]];
            } else {
                // 昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:needFormatDate]];
            }
        } else {
            [dateFormatter setDateFormat:@"yyyy"];
            NSString *yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
                        if ([yearStr isEqualToString:nowYear]) {
                            // 在同一年
                            [dateFormatter setDateFormat:@"MM月dd日"];
                            dateStr = [dateFormatter stringFromDate:needFormatDate];
                        } else {
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
                        }
        }
        return dateStr;
    } @catch (NSException *exception) {
        return @"";
    }
}

/**
 *  返回特定的时间格式
 *  若是当天则显示为：上午9:40；
 *  若时间大于1天，则显示为：昨天；；
 *  若时间大于2天，则显示日期为:16-1-2
 *  @param dateString
 *
 *  @return
 */
+ (NSString *)certainDateWithString:(NSString *)dateString {
    return [self certainDateWithData:[self stringToDate:dateString]];
}
/**
 *  返回特定的时间格式
 *  若是当天则显示为：上午9:40；
 *  若时间大于1天，则显示为：昨天；；
 *  若时间大于2天，则显示日期为:16-1-2
 *  @param dateString
 *
 *  @return
 */
+ (NSString *)certainDateWithData:(NSDate *)date {
    @try {
        // 日期格式
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *nowDate = [NSDate date];
        NSDate *yesterDay = [NSDate dateWithTimeIntervalSinceNow:(-60 * 60 * 24)];
        // 将需要转换的时间转换成 NSDate 对象
        NSDate *needFormatDate = date;
        
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        NSString *dateStr = @"";
        
        if (time <= 60 * 60 * 24) {
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString *need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            if ([need_yMd isEqualToString:now_yMd]) {
                //同一天
                [dateFormatter setDateFormat:@"ah:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            } else {
                dateStr = @"昨天";
            }
            
        } else if (time > 60 * 60 * 24 && time <= 60 * 60 * 48) {
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString *need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *yesterDay_yMd = [dateFormatter stringFromDate:yesterDay];
            if ([need_yMd isEqualToString:yesterDay_yMd]) {
                //同一天
                dateStr = @"昨天";
            } else {
                // 前天
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
            
            
        } else {
            // 大于两天
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }
        
        return dateStr;
    } @catch (NSException *exception) {
        return @"";
    }
}

/**
 *  格式化 NSDate
 *
 *  @param date
 *  @param format
 *
 *  @return
 */
+ (NSString *)formatDate:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:date];
}

/**
 *  格式化 NSDate
 *
 *  @param dateString
 *  @param format
 *
 *  @return
 */
+ (NSString *)formatDateString:(NSString *)dateString format:(NSString *)format {
    return [self formatDate:[self stringToDate:dateString] format:format];
}

/**
 *  1970 vs 2001 core date数据库数据:2016/03/01 09:21:57  mfdb读出来为 1985/03/01 09:21:57 然后再转为 2016/03/01 09:21:57
 *
 *  @param date1
 *
 *  @return
 */
+ (NSDate *)formatDateSince2011By1970:(NSDate *)date {
    NSTimeInterval interval = [date timeIntervalSince1970];
    return [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
}

/**
 *  比较两个date之间的间隔天数
 *
 *  @param fromDateTime fromDateTime description
 *  @param toDateTime   toDateTime description
 *
 *  @return 
 */
+ (NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime {
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

@end
