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

#import <objc/runtime.h>

@interface UVDataRecognizer ()

@property (nonatomic, retain, readwrite) id<UVRSSLinkXMLParserType> linkXMLParser;

@end

static NSInteger const TIMEOUT = 1;

@interface UVDataRecognizerTests : XCTestCase

@property (nonatomic, retain) UVDataRecognizer *sut;
@property (nonatomic, retain) UVFeedParserMock *feedParser;
@property (nonatomic, retain) UVRSSLinkXMLParserMock *linksParser;

@end

@implementation UVDataRecognizerTests

- (id<UVRSSLinkXMLParserType>)mockParserMethod {
    return [self.linksParser copy];
}

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

- (void)testXMLChannelDiscoveringNilDataProvidedErrorOccures {
    NSData *data = RSSDataFactory.rawDataNil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"nil data error didn't occure"];

    [self.sut discoverChannel:data
                       parser:self.feedParser
                   completion:^(NSDictionary *result, NSError *error) {
        XCTAssertNil(result);
        XCTAssertNotNil(error);
        XCTAssertFalse(self.feedParser.isCalled);
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testXMLChannelDiscoveringNilPraserProvidedErrorOccures {
    NSData *data = RSSDataFactory.rawXMLData;
    id<UVFeedParserType> parser = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"nil parser error didn't occure"];

    [self.sut discoverChannel:data
                       parser:parser
                   completion:^(NSDictionary *result, NSError *error) {
        XCTAssertNil(result);
        XCTAssertNotNil(error);
        XCTAssertFalse(self.feedParser.isCalled);
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testXMLChannelDiscoveringParserInternalErrorOccures {
    NSData *data = RSSDataFactory.rawXMLData;
    self.feedParser.errorToReturn = SwissKnife.mockError;
    XCTestExpectation *expectation = [self expectationWithDescription:@"parser internal error didn't occure"];

    [self.sut discoverChannel:data
                       parser:self.feedParser
                   completion:^(NSDictionary *result, NSError *error) {
        XCTAssertTrue(self.feedParser.isCalled);
        XCTAssertNil(result);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testXMLChannelDiscoveringDataProcessedChannelProvidedNormally {
    NSData *data = RSSDataFactory.rawXMLData;
    self.feedParser.dictionaryToReturn = RSSDataFactory.rawChannel;
    XCTestExpectation *expectation = [self expectationWithDescription:@"channel raw data isn't parsed"];

    [self.sut discoverChannel:data
                       parser:self.feedParser
                   completion:^(NSDictionary *result, NSError *error) {
        XCTAssertTrue(self.feedParser.isCalled);
        XCTAssertNotNil(result);
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testHTMLLinksDiscoveringNilDataProvidedErrorOccures {
    NSData *data = RSSDataFactory.rawDataNil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"nil data error didn't occure"];
    
    [self.sut discoverLinksFromHTML:data
                         completion:^(NSArray<NSDictionary *> *result, NSError *error) {
        XCTAssertNil(result);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testNotHTMLLinksDiscoveringDataProvidedErrorOccures {
    NSData *data = RSSDataFactory.rawGarbageData;
    XCTestExpectation *expectation = [self expectationWithDescription:@"nil data error didn't occure"];

    [self.sut discoverLinksFromHTML:data
                         completion:^(NSArray<NSDictionary *> *result, NSError *error) {
        XCTAssertNil(result);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testHTMLLinksDiscoveringDataContainsNoRSSLinksErrorOccures {
    NSData *data = RSSDataFactory.rawHTMLDataNoRSS;
    XCTestExpectation *expectation = [self expectationWithDescription:@"no rss links in html error occured"];

    [self.sut discoverLinksFromHTML:data
                         completion:^(NSArray<NSDictionary *> *result, NSError *error) {
        XCTAssertNil(result);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testHTMLLinksDiscoveringDataRSSLinksNormallyProvided {
    NSData *data = RSSDataFactory.rawHTMLData;
    NSArray *expected = RSSDataFactory.rawLinksFromHTML;
    XCTestExpectation *expectation = [self expectationWithDescription:@"no rss links in html error didn't occure"];

    [self.sut discoverLinksFromHTML:data completion:^(NSArray<NSDictionary *> *result, NSError *error) {
        XCTAssertNotNil(result);
        XCTAssertNil(error);
        XCTAssertEqual(expected.count, result.count);
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testXMLLinksDiscoveringNoDataProvidedErrorOccures {
    NSData *data = RSSDataFactory.rawDataNil;
    NSURL *url = SwissKnife.mockURL;
    XCTestExpectation *expectation = [self expectationWithDescription:@"no data provided error didn't occure"];
    [self.sut discoverLinksFromXML:data
                               url:url
                        completion:^(NSArray<NSDictionary *> *result, NSError *error) {
        XCTAssertFalse(self.linksParser.isCalled);
        XCTAssertNil(result);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testXMLLinksDiscoveringNoURLProvidedErrorOccures {
    NSData *data = RSSDataFactory.rawXMLData;
    NSURL *url = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"no url provided error didn't occure"];
    [self.sut discoverLinksFromXML:data
                               url:url
                        completion:^(NSArray<NSDictionary *> *result, NSError *error) {
        XCTAssertFalse(self.linksParser.isCalled);
        XCTAssertNil(result);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testXMLLinksDiscoveringDataParserInternalErrorOccures {
    NSData *data = RSSDataFactory.rawXMLData;
    NSURL *url = SwissKnife.mockURL;
    self.linksParser.errorToReturn = SwissKnife.mockError;
    
    Method sut_method = class_getInstanceMethod(self.sut.class, NSSelectorFromString(@"linkXMLParser"));
    IMP sut_mock_imp = imp_implementationWithBlock(^id(id self_){
        return self.linksParser;
    });
    method_setImplementation(sut_method, sut_mock_imp);

    XCTestExpectation *expectation = [self expectationWithDescription:@"no rss links in html error occured"];

    [self.sut discoverLinksFromXML:data url:url completion:^(NSArray<NSDictionary *> *result, NSError *error) {
        XCTAssertTrue(self.linksParser.isCalled);
        XCTAssertNotNil(error);
        XCTAssertNil(result);

        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testXMLLinksDiscoveringDataParserLinksProvided {
    NSData *data = RSSDataFactory.rawXMLData;
    NSURL *url = SwissKnife.mockURL;
    self.linksParser.dictionaryToReturn = RSSDataFactory.rawLinkFromXML;

    Method sut_method = class_getInstanceMethod(self.sut.class, NSSelectorFromString(@"linkXMLParser"));
    IMP sut_mock_imp = imp_implementationWithBlock(^id(id self_){
        return self.linksParser;
    });
    method_setImplementation(sut_method, sut_mock_imp);
    XCTestExpectation *expectation = [self expectationWithDescription:@"no rss links in html error occured"];

    [self.sut discoverLinksFromXML:data url:url completion:^(NSArray<NSDictionary *> *result, NSError *error) {
        XCTAssertTrue(self.linksParser.isCalled);
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testContentTypeDiscoveringNilDataProvidedErrorOccures {
    NSData *data = RSSDataFactory.rawDataNil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"nil data error didn't occure"];
    
    [self.sut discoverContentType:data
                       completion:^(UVRawContentType type, NSError *error) {
        XCTAssertEqual(UVRawContentUndefined, type);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testContentTypeDiscoveringXMLTypeReturnedFromData {
    NSData *data = RSSDataFactory.rawXMLData;
    XCTestExpectation *expectation = [self expectationWithDescription:@"nil data error didn't occure"];
    
    [self.sut discoverContentType:data
                       completion:^(UVRawContentType type, NSError *error) {
        XCTAssertEqual(UVRawContentXML, type);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testContentTypeDiscoveringHTMLTypeReturnedFromData {
    NSData *data = RSSDataFactory.rawHTMLData;
    XCTestExpectation *expectation = [self expectationWithDescription:@"nil data error didn't occure"];
    
    [self.sut discoverContentType:data
                       completion:^(UVRawContentType type, NSError *error) {
        XCTAssertEqual(UVRawContentHTML, type);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testContentTypeDiscoveringUndefinedTypeReturnedFromData {
    NSData *data = RSSDataFactory.rawGarbageData;
    XCTestExpectation *expectation = [self expectationWithDescription:@"nil data error didn't occure"];
    
    [self.sut discoverContentType:data
                       completion:^(UVRawContentType type, NSError *error) {
        XCTAssertEqual(UVRawContentUndefined, type);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

@end
