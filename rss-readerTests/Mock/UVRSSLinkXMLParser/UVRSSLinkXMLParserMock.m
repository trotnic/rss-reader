//
//  UVRSSLinkXMLParserMock.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 8.01.21.
//

#import "UVRSSLinkXMLParserMock.h"

@implementation UVRSSLinkXMLParserMock

- (void)parseData:(NSData *)data
       completion:(void (^)(NSDictionary *, NSError *))completion {
    self.isCalled = YES;
    self.providedData = data;
    if (completion) completion(self.dictionaryToReturn, self.errorToReturn);
}

@end
