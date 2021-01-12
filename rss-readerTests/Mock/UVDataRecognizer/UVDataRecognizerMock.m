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
    self.providedParser = parser;
    completion(self.rawChannelToReturn, self.discoverChannelErrorToReturn);
}

- (void)discoverContentType:(NSData *)data
                 completion:(void (^)(UVRawContentType, NSError *))completion {
    self.isCalled = YES;
    self.providedContentData = data;
    completion(self.contentTypeToReturn, self.discoverContentErrorToReturn);
}


- (void)discoverLinksFromHTML:(NSData *)data
                   completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    self.isCalled = YES;
    self.providedHTMLData = data;
    completion(self.rawLinksHTMLToReturn, self.discoverHTMLErrorToReturn);
    
}


- (void)discoverLinksFromXML:(NSData *)data
                         url:(NSURL *)url
                  completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    self.isCalled = YES;
    self.providedXMLData = data;
    self.providedURL = url;
    completion(self.rawLinksXMLToReturn, self.discoverXMLErrorToReturn);
}


@end
