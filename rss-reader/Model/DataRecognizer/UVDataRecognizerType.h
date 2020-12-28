//
//  UVDataRecognizerType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <Foundation/Foundation.h>
#import "RSSLink.h"
#import "RSSError.h"
#import "FeedParserType.h"

NS_ASSUME_NONNULL_BEGIN


@protocol UVDataRecognizerType <NSObject>

- (void)processData:(NSData *)data completion:(void (^)(NSArray<RSSLink *> *, RSSError))completion;
- (void)processData:(NSData *)data parser:(id<FeedParserType>)parser completion:(void(^)(FeedChannel *, RSSError))completion;

@end

NS_ASSUME_NONNULL_END
