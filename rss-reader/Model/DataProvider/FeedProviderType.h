//
//  FeedProviderType.h
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import <Foundation/Foundation.h>
#import "FeedParserType.h"
#import "FeedChannel.h"
#import "RSSError.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FeedProviderType <NSObject>

- (void)discoverChannel:(NSData *)data
                 parser:(id<FeedParserType>)parser
             completion:(void(^)(FeedChannel *, RSSError))completion;

@end

NS_ASSUME_NONNULL_END
