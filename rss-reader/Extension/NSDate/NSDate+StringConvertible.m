//
//  NSDate+StringInitializable.m
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import "NSDate+StringConvertible.h"
#import "NSDateFormatter+FormatInitializable.h"

@implementation NSDate (StringConvertible)

+ (instancetype)dateFromString:(NSString *)string
                    withFormat:(NSString *)format {
    return [[NSDateFormatter dateFormatterWithFormat:format] dateFromString:string];
}

- (NSString *)stringWithFormat:(NSString *)format {
    return [[NSDateFormatter dateFormatterWithFormat:format] stringFromDate:self];
}

@end
