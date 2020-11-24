//
//  NSDate+StringInitializable.m
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import "NSDate+StringConvertible.h"

@implementation NSDate (StringConvertible)

+ (instancetype)dateFromString:(NSString *)string
                    withFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter new] autorelease];
    formatter.dateFormat = format;
    return [formatter dateFromString:string];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter new] autorelease];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

@end
