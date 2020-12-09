//
//  NSXMLParser+DelegateInitializable.h
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSXMLParser (DelegateInitializable)

+ (instancetype)parserWithData:(NSData *)data delegate:(id<NSXMLParserDelegate>)delegate;
+ (instancetype)parserWithURL:(NSURL *)url delegate:(id<NSXMLParserDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
