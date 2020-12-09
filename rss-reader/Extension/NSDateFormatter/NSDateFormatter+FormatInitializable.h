//
//  NSDateFormatter+FormatInitializable.h
//  rss-reader
//
//  Created by Uladzislau on 11/25/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter (FormatInitializable)

+ (instancetype)dateFormatterWithFormat:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
