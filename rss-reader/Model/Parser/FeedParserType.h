//
//  FeedParser.h
//  rss-reader
//
//  Created by Uladzislau on 11/19/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FeedChannel;
typedef void(^ParseHandler)(FeedChannel *_Nullable, NSError *_Nullable);

@protocol FeedParserType <NSObject>

- (void)parseData:(NSData *)data withCompletion:(ParseHandler)completion;
- (void)parseContentsOfURL:(NSURL *)url withCompletion:(ParseHandler)completion;

@end

NS_ASSUME_NONNULL_END
