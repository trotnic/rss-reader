//
//  NSDate+StringInitializable.h
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (StringConvertible)

+ (instancetype)dateFromString:(NSString *)string withFormat:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
