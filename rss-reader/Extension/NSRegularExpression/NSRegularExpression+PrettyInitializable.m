//
//  NSRegularExpression+PrettyInitializable.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import "NSRegularExpression+PrettyInitializable.h"

@implementation NSRegularExpression (PrettyInitializable)

+ (instancetype)expressionWithPattern:(NSString *)string {
    if(!string) {
        return nil;
    }
    return [NSRegularExpression regularExpressionWithPattern:string options:NSRegularExpressionCaseInsensitive error:nil];
}

@end
