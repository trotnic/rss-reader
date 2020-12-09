//
//  NSDateFormatter+FormatInitializable.m
//  rss-reader
//
//  Created by Uladzislau on 11/25/20.
//

#import "NSDateFormatter+FormatInitializable.h"

@implementation NSDateFormatter (FormatInitializable)

+ (instancetype)dateFormatterWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = format;
    return [formatter autorelease];
}

@end
