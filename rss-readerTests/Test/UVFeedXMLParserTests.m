//
//  FeedXMLParserTests.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 1.01.21.
//

#import <XCTest/XCTest.h>
#import "UVFeedXMLParser.h"
#import "RSSDataFactory.h"

@interface UVFeedXMLParserTests : XCTestCase

@property (nonatomic, retain) UVFeedXMLParser *sut;
@property (nonatomic, retain) NSData *rawData;

@end

@implementation UVFeedXMLParserTests

- (void)setUp {
    _sut = [UVFeedXMLParser new];
    self.rawData = RSSDataFactory.rawData;
}

- (void)tearDown {
    [_sut release];
    [_rawData release];
    _sut = nil;
}

- (void)testChannelIsNotNil {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Raw data is parsed"];
    [self.sut parseData:self.rawData
             completion:^(NSDictionary *rawChannel, NSError *error) {
        XCTAssertNotNil(rawChannel);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testParserIsFailed {
    NSData *rawData = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Raw data is parsed"];
    [self.sut parseData:rawData
             completion:^(NSDictionary *rawChannel, NSError *error) {
        XCTAssertNil(rawChannel);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testChannelIsParsedCorrectly {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Raw data is parsed"];
    NSDictionary *expected = RSSDataFactory.rawChannel;
    [self.sut parseData:self.rawData
             completion:^(NSDictionary *rawChannel, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqual(expected.count, rawChannel.count);
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:1];
}

@end
