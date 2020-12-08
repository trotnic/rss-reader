//
//  NSRegularExpression+PrettyInitializable.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSRegularExpression (PrettyInitializable)

+ (instancetype)expressionWithPattern:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
