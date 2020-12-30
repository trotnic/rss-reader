//
//  NSArray+Util.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 21.12.20.
//

#import "NSArray+Util.h"

@implementation NSArray (Util)

- (NSArray *)map:(id  _Nonnull (^)(id _Nonnull))completion {
    NSMutableArray *array = [NSMutableArray array];
    for (id object in self) {
        [array addObject:completion(object)];
    }
    return [[array copy] autorelease];
}

- (void)forEach:(void (^)(id _Nonnull))completion {
    for (id obj in self) {
        completion(obj);
    }
}

- (id)find:(BOOL (^)(id _Nonnull))completion {
    for (id obj in self) {
        if (completion(obj)) {
            return obj;
        }
    }
    return nil;
}

@end
