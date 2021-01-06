//
//  SwithKnife.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import "SwissKnife.h"

@implementation SwissKnife

+ (NSError *)mockError {
    return [NSError errorWithDomain:@"uvolchyk.testsuite" code:200000 userInfo:nil];
}

+ (NSURL *)mockURL {
    return [NSURL URLWithString:@"https://tut.by"];
}

@end
