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
       completion:(void (^)(NSDictionary *, NSError *))completion {
    self.isCalled = YES;
    if (completion) completion(self.rawChannel, self.error);
}

- (void)parseContentsOfURL:(NSURL *)url
                completion:(void (^)(NSDictionary *, NSError *))completion {
    self.isCalled = YES;
    if (completion) completion(self.rawChannel, self.error);
}

@end
