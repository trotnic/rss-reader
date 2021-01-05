//
//  UVFeedProvider.m
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import "UVFeedProvider.h"
#import "UVFeedParserType.h"
#import "UVErrorDomain.h"

@interface UVFeedProvider ()

@end

@implementation UVFeedProvider

// MARK: - FeedProviderType

- (void)discoverChannel:(NSData *)data
                 parser:(id<UVFeedParserType>)parser
             completion:(void(^)(UVFeedChannel *, NSError *))completion {
    if(!data) {
        completion(nil, [self discoveringError]);
        return;
    }
    [parser retain];
    [parser parseData:data
           completion:^(UVFeedChannel *channel, NSError *error) {
        completion(channel, error);
        [parser release];
    }];
}

// MARK: - Private

- (NSError *)discoveringError {
    return [NSError errorWithDomain:UVNullDataErrorDomain code:1000 userInfo:nil];
}

@end
