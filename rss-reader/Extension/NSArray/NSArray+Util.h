//
//  NSArray+Util.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 21.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Util)

- (NSArray *)map:(id(^)(id))completion;
- (NSArray *)compactMap:(id(^)(id))completion;
- (NSArray *)filter:(BOOL(^)(id))completion;
- (void)forEach:(void(^)(id))completion;
- (id _Nullable)find:(BOOL(^)(id))completion;

@end

NS_ASSUME_NONNULL_END
