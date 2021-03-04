//
//  UVFeedParserMock.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 8.01.21.
//

#import "UVFeedParserMock.h"

@implementation UVFeedParserMock

- (void)parseContentsOfURL:(NSURL *)url
                completion:(void (^)(NSDictionary *, NSError *))completion {
    self.isCalled = YES;
    self.urlProvided = url;
    if (completion) completion(self.dictionaryToReturn, self.errorToReturn);
}

- (void)parseData:(NSData *)data
       completion:(void (^)(NSDictionary *, NSError *))completion {
    self.isCalled = YES;
    self.dataProvided = data;
    if (completion) completion(self.dictionaryToReturn, self.errorToReturn);
}

@end
