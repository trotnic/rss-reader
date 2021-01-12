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
    return [array copy];
}

- (NSArray *)compactMap:(id  _Nonnull (^)(id _Nonnull))completion {
    NSMutableArray *array = [NSMutableArray array];
    for (id object in self) {
        id result = completion(object);
        if (result) {
            [array addObject:result];
        }
    }
    return [array copy];
}

- (NSArray *)filter:(BOOL (^)(id _Nonnull))completion {
    NSMutableArray *array = [NSMutableArray array];
    for (id object in self) {
        if (completion(object)) {
            [array addObject:object];
        }
    }
    return [array copy];
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
