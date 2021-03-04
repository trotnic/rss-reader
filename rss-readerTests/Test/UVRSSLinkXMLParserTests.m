//
//  UVRSSLinkXMLParserTests.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 8.01.21.
//

#import <XCTest/XCTest.h>
#import "UVRSSLinkXMLParser.h"
#import "RSSDataFactory.h"

@interface UVRSSLinkXMLParserTests : XCTestCase

@property (nonatomic, retain) UVRSSLinkXMLParser *sut;

@end

@implementation UVRSSLinkXMLParserTests

- (void)setUp {
    _sut = [UVRSSLinkXMLParser new];
}

- (void)tearDown {
    [_sut release];
}

- (void)testNilDataProvidedErrorOccures {
    NSData *data = RSSDataFactory.rawDataNil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"nil data provided error occured"];
    
    [self.sut parseData:data
             completion:^(NSDictionary *result, NSError *error) {
        XCTAssertNil(result);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testNotXMLDataProvidedErrorOccures {
    NSData *data = RSSDataFactory.rawGarbageData;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"nil data provided error occured"];
    
    [self.sut parseData:data
             completion:^(NSDictionary *result, NSError *error) {
        XCTAssertNil(result);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testLinksNormallyProvided {
    NSData *data = RSSDataFactory.rawXMLData;
    NSDictionary *expected = RSSDataFactory.rawLinkFromXML;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"nil data provided error occured"];
    
    [self.sut parseData:data
             completion:^(NSDictionary *result, NSError *error) {
        XCTAssertNotNil(result);
        XCTAssertNil(error);
        XCTAssertEqual(expected.count, result.count);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1];
}

@end
