//
//  NSURL+Util.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import "NSURL+Util.h"

NSString *const urlMatchPattern = @"(http|https)*(://)*((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))";

@implementation NSURL (Util)

+ (BOOL)isStringValid:(NSString *)string {
    NSRegularExpression *urlRegExp = [NSRegularExpression regularExpressionWithPattern:urlMatchPattern options:0 error:nil];
    NSTextCheckingResult *match = [urlRegExp firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    return match != nil;
}

@end
