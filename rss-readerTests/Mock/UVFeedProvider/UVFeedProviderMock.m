//
//  UVFeedProviderMock.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import "UVFeedProviderMock.h"

@implementation UVFeedProviderMock

- (void)discoverChannel:(NSData *)data
                 parser:(id<UVFeedParserType>)parser
             completion:(void (^)(UVFeedChannel *, NSError *))completion {
    self.isCalled = YES;
    completion(self.channel, self.error);
}

@end
