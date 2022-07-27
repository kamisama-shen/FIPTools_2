//
//  NSDate+DLExtension.h
//  Auction
//
//  Created by liangHzhang on 14-12-10.
//
//

#import <UIKit/UIKit.h>


@interface NSDate(DLExtension)


/*
  返回年月日，如2016-12-01
*/
-(NSString *)dateToString;
/*
 返回年月日，小时，分钟，秒，如2016-12-01 10:45:45
*/
-(NSString *)timeToString;
/*
 返回年月日，小时，分钟，如2016-12-01 10:45
 */
-(NSString *)timeToMMString;
/*
 根据传入的NSDateFormatter格式，返回对应的时间字符。
 */
-(NSString*)dateFormat:(NSString*)format;
/*
 返回系统的当前时间(精确到秒)，如2016-12-01 10:45:45
 */
+(NSString*)systemTime;
/*
 返回系统的当前时间(精确到分钟)，如2016-12-01 10:45
 */
+(NSString*)systemTimeToMM;

-(NSDate *)offsetMonth:(int)numMonths;
-(NSDate *)offsetDay:(int)numDays;
-(NSDate *)offsetHours:(int)hours;
-(NSInteger)numDaysInMonth;
-(NSInteger)firstWeekDayInMonth;

+(NSDate *)dateStartOfDay:(NSDate *)date;
+(NSDate *)dateStartOfWeek;
+(NSDate *)dateEndOfWeek;

//是否是今年
-(BOOL)isThisYear;

+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second;

+ (NSInteger)daysOffsetBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

+ (NSDate *)dateWithHour:(int)hour
                  minute:(int)minute;

#pragma mark - Getter
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
- (NSString *)dayOfWeek;


#pragma mark - Time string
- (NSString *)timeHourMinute;
- (NSString *)timeHourMinuteWithPrefix;
- (NSString *)timeHourMinuteWithSuffix;
- (NSString *)timeHourMinuteWithPrefix:(BOOL)enablePrefix suffix:(BOOL)enableSuffix;

#pragma mark - Date String
- (NSString *)stringTime;
- (NSString *)stringMonthDay;
- (NSString *)stringYearMonthDay;
- (NSString *)stringYearMonthDayHourMinuteSecond;
+ (NSString *)stringYearMonthDayWithDate:(NSDate *)date;//date为空时返回的是当前年月日
+ (NSString *)stringLoacalDate;

#pragma mark - Date formate
+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)timestampFormatStringSubSeconds;

#pragma mark - Date adjust
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;

#pragma mark - Relative dates from the date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;
+ (NSDate *) dateStandardFormatTimeZeroWithDate: (NSDate *) aDate;  //标准格式的零点日期
- (NSInteger) daysBetweenCurrentDateAndDate; //负数为过去，正数为未来

#pragma mark - Date compare
- (NSString *)stringYearMonthDayCompareToday; //返回“今天”，“明天”，“昨天”，或年月日

#pragma mark - Date and string convert
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
- (NSString *)string;
- (NSString *)stringCutSeconds;


@end
