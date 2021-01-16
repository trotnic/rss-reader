//
//  FeedXMLParserTests.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 1.01.21.
//

#import <XCTest/XCTest.h>
#import "UVFeedXMLParser.h"
#import "UVFeedChannel.h"
#import "RSSFeeDataFactory.h"

@interface UVFeedXMLParserTests : XCTestCase

@property (nonatomic, retain) UVFeedXMLParser *sut;
@property (nonatomic, retain) NSData *rawData;

@end

@implementation UVFeedXMLParserTests

- (void)setUp {
    _sut = [UVFeedXMLParser new];
    self.rawData = RSSFeeDataFactory.rawData;
}

- (void)tearDown {
    [_sut release];
    [_rawData release];
    _sut = nil;
}

- (void)testChannelIsNotNil {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Raw data is parsed"];
    [self.sut parseData:self.rawData
             completion:^(UVFeedChannel *channel, NSError *error) {
        XCTAssertNotNil(channel);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testParserIsFailed {
    NSData *rawData = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Raw data is parsed"];
    [self.sut parseData:rawData
             completion:^(UVFeedChannel *channel, NSError *error) {
        XCTAssertNil(channel);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testChannelIsParsedCorrectly {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Raw data is parsed"];
    UVFeedChannel *expected = RSSFeeDataFactory.channel;
    [self.sut parseData:self.rawData
             completion:^(UVFeedChannel *channel, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqualObjects(channel.title, expected.title);
        XCTAssertEqualObjects(channel.link, expected.link);
        XCTAssertTrue([channel.items containsObject:expected.items.firstObject]);
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:1];
}

@end
