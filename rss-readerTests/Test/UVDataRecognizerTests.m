//
//  UVDataRecognizerTests.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 8.01.21.
//

#import <XCTest/XCTest.h>
#import "UVDataRecognizer.h"
#import "UVFeedParserMock.h"
#import "UVRSSLinkXMLParserMock.h"
#import "RSSDataFactory.h"
#import "SwissKnife.h"

@interface UVDataRecognizerTests : XCTestCase

@property (nonatomic, retain) UVDataRecognizer *sut;
@property (nonatomic, retain) UVFeedParserMock *feedParser;
@property (nonatomic, retain) UVRSSLinkXMLParserMock *linksParser;

@end

@implementation UVDataRecognizerTests

- (void)setUp {
    _sut = [UVDataRecognizer new];
    _feedParser = [UVFeedParserMock new];
    _linksParser = [UVRSSLinkXMLParserMock new];
}

- (void)tearDown {
    [_sut release];
    [_feedParser release];
    [_linksParser release];
}

- (void)testXMLnilDataProvidedErrorOccures {
    NSData *data = RSSDataFactory.rawDataNil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"nil data error occured"];
    
    [self.sut discoverChannel:data
                       parser:self.feedParser
                   completion:^(NSDictionary *result, NSError *error) {
        XCTAssertNil(result);
        XCTAssertNotNil(error);
        XCTAssertFalse(self.feedParser.isCalled);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testXMLParserNoProvidedErrorOccures {
    NSData *data = RSSDataFactory.rawXMLData;
    id<UVFeedParserType> parser = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"nil parser error occured"];
    
    [self.sut discoverChannel:data
                       parser:parser
                   completion:^(NSDictionary *result, NSError *error) {
        XCTAssertNil(result);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testXMLParserInternalErrorOccures {
    NSData *data = RSSDataFactory.rawXMLData;
    self.feedParser.errorToReturn = SwissKnife.mockError;
    XCTestExpectation *expectation = [self expectationWithDescription:@"parser internal error occured"];
    
    [self.sut discoverChannel:data
                       parser:self.feedParser
                   completion:^(NSDictionary *result, NSError *error) {
        XCTAssertTrue(self.feedParser.isCalled);
        XCTAssertNil(result);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1];

}

- (void)testXMLDataProcessedChannelProvided {
    NSData *data = RSSDataFactory.rawXMLData;
    self.feedParser.dictionaryToReturn = RSSDataFactory.rawChannel;
    XCTestExpectation *expectation = [self expectationWithDescription:@"channel raw data parsed"];
    
    [self.sut discoverChannel:data
                       parser:self.feedParser
                   completion:^(NSDictionary *result, NSError *error) {
        XCTAssertTrue(self.feedParser.isCalled);
        XCTAssertNotNil(result);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testHTMLnilDataProvidedErrorOccures {
    NSData *data = RSSDataFactory.rawDataNil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"nil data error occured"];
    
    [self.sut discoverLinks:data
                 completion:^(NSArray<NSDictionary *> *result, NSError *error) {
        XCTAssertNil(result);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testNotHTMLDataProvidedErrorOccures {
    NSData *data = RSSDataFactory.rawGarbageData;
    XCTestExpectation *expectation = [self expectationWithDescription:@"nil data error occured"];
    
    [self.sut discoverLinks:data
                 completion:^(NSArray<NSDictionary *> *result, NSError *error) {
        XCTAssertNil(result);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testHTMLDataContainsNoRSSLinksErrorOccures {
    NSData *data = RSSDataFactory.rawHTMLDataNoRSS;
    XCTestExpectation *expectation = [self expectationWithDescription:@"no rss links in html error occured"];
    
    [self.sut discoverLinks:data
                 completion:^(NSArray<NSDictionary *> *result, NSError *error) {
        XCTAssertNil(result);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testHTMLDataRSSLinksNormallyProvided {
    NSData *data = RSSDataFactory.rawHTMLData;
    NSArray *expected = RSSDataFactory.sourceWithLinksSelectedYES.rssLinks;
    XCTestExpectation *expectation = [self expectationWithDescription:@"no rss links in html error occured"];
    
    [self.sut discoverLinks:data
                 completion:^(NSArray<NSDictionary *> *result, NSError *error) {
        XCTAssertNotNil(result);
        XCTAssertNil(error);
        XCTAssertEqual(expected.count, result.count);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testXMLDataParserInternalErrorOccures {
    NSData *data = RSSDataFactory.rawXMLData;
    self.linksParser.errorToReturn = SwissKnife.mockError;
    [self.sut setValue:self.linksParser forKey:@"linkXMLParser"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"no rss links in html error occured"];
    
    [self.sut discoverLinks:data
                 completion:^(NSArray<NSDictionary *> *result, NSError *error) {
        XCTAssertTrue(self.linksParser.isCalled);
        XCTAssertNotNil(error);
        XCTAssertNil(result);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testXMLDataParserLinksProvided {
    NSData *data = RSSDataFactory.rawXMLData;
    self.linksParser.dictionaryToReturn = RSSDataFactory.rawLinkFromXML;
    NSArray<NSDictionary *> *expected = @[RSSDataFactory.rawLinkFromXML];
    
    [self.sut setValue:self.linksParser forKey:@"linkXMLParser"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"no rss links in html error occured"];
    
    [self.sut discoverLinks:data
                 completion:^(NSArray<NSDictionary *> *result, NSError *error) {
        XCTAssertTrue(self.linksParser.isCalled);
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertEqual(expected.count, result.count);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1];
}


@end
