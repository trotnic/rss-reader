//
//  NSString+StringExtractor.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12/1/20.
//

#import "NSString+StringExtractor.h"

@implementation NSString (StringExtractor)

- (NSString *)stringBetweenStart:(NSString *)start andFinish:(NSString *)finish {
    NSRange utilityRange = [self rangeOfString:start];
    if (utilityRange.location == NSNotFound) { return self; }
    NSString *resultString = [self substringFromIndex:utilityRange.location + start.length];
    utilityRange = [resultString rangeOfString:finish];
    if (utilityRange.location == NSNotFound) { return resultString; }
    resultString = [resultString substringToIndex:utilityRange.location];
    return resultString;
}

- (NSString *)substringFromString:(NSString *)string {
    NSString *pattern = [NSString stringWithFormat:@"(?<=%@).+", string];
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSTextCheckingResult *result = [regExp firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (result.range.location == NSNotFound || !result) return self;
    return [self substringWithRange:result.range];
}

@end
