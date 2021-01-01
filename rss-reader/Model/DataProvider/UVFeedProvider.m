//
//  FeedProvider.m
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import "UVFeedProvider.h"
#import "FeedParserType.h"

@interface UVFeedProvider ()

@end

@implementation UVFeedProvider

// MARK: - FeedProviderType

- (void)discoverChannel:(NSData *)data
                 parser:(id<FeedParserType>)parser
             completion:(void(^)(FeedChannel *, RSSError))completion {
    [parser retain];
    [parser parseData:data
           completion:^(FeedChannel *channel, NSError *error) {
        if(error) {
            completion(nil, RSSErrorTypeParsingError);
            [parser release];
            return;
        }
        completion(channel, RSSErrorTypeNone);
        [parser release];
    }];
}

@end
