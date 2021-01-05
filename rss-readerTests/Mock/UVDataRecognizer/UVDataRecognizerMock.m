//
//  UVDataRecognizerMock.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 3.01.21.
//

#import "UVDataRecognizerMock.h"

@implementation UVDataRecognizerMock

- (void)discoverChannel:(NSData *)data
                 parser:(id<UVFeedParserType>)parser
             completion:(void (^)(NSDictionary *, NSError *))completion {
    self.isCalled = YES;
    completion(self.rawChannel, self.error);
}

- (void)discoverLinks:(NSData *)data
           completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    self.isCalled = YES;
    completion(self.rawLinks, self.error);
}

@end
