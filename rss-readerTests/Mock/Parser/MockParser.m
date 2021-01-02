//
//  MockParser.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import "MockParser.h"

@implementation MockParser

+ (instancetype)parser {
    return [[MockParser new] autorelease];
}

- (void)parseData:(NSData *)data
       completion:(void (^)(UVFeedChannel *, NSError *))completion {
    self.isCalled = YES;
    completion(self.channel, self.error);
}

- (void)parseContentsOfURL:(NSURL *)url
                completion:(void (^)(UVFeedChannel *, NSError *))completion {
    self.isCalled = YES;
    completion(self.channel, self.error);
}

@end
