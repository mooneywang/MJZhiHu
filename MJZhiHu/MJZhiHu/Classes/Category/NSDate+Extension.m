//
//  NSDate+Extension.m
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/6/1.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSString *)dateBeforeDate:(NSString *)dateString {
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    [dateF setDateFormat:@"yyyyMMdd"];
    NSDate *date = [dateF dateFromString:dateString];
    // 前一天
    NSDate *formerDate = [date dateByAddingTimeInterval:-24 * 60 *60];
    return [dateF stringFromDate:formerDate];
}

@end
