////
////  UVFeedProviderTests.m
////  rss-readerTests
////
////  Created by Uladzislau Volchyk on 2.01.21.
////
//
//#import <XCTest/XCTest.h>
//#import "MockParser.h"
//#import "UVFeedProvider.h"
//#import "RSSFeeDataFactory.h"
//#import "SwissKnife.h"
//
//@interface UVFeedProviderTests : XCTestCase
//
//@property (nonatomic, retain) UVFeedProvider *sut;
//@property (nonatomic, retain) MockParser *parser;
//
//@end
//
//@implementation UVFeedProviderTests
//
//- (void)setUp {
//    _sut = [UVFeedProvider new];
//    _parser = [MockParser new];
//}
//
//- (void)tearDown {
//    [_sut release];
//    [_parser release];
//}
//
//- (void)testArbitraryParserErrorOccured {
//    MockParser *parser = MockParser.parser;
//    parser.error = SwissKnife.mockError;
//    XCTestExpectation *expectation = [self expectationWithDescription:@"Parser error occured"];
//    
//    [self.sut discoverChannel:RSSFeeDataFactory.rawData
//                       parser:parser
//                   completion:^(UVFeedChannel *channel, NSError *error) {
//        XCTAssertNil(channel);
//        XCTAssertTrue(parser.isCalled);
//        XCTAssertNotNil(error);
//        [expectation fulfill];
//    }];
//    
//    [self waitForExpectations:@[expectation] timeout:1];
//}
//
//- (void)testNilRawDataParserErrorOccured {
//    MockParser *parser = MockParser.parser;
//    NSData *rawData = nil;
//    XCTestExpectation *expectation = [self expectationWithDescription:@"Parser error occured"];
//    
//    [self.sut discoverChannel:rawData
//                       parser:parser
//                   completion:^(UVFeedChannel *channel, NSError *error) {
//        XCTAssertNil(channel);
//        XCTAssertFalse(parser.isCalled);
//        XCTAssertNotNil(error);
//        [expectation fulfill];
//    }];
//    
//    [self waitForExpectations:@[expectation] timeout:1];
//}
//
//- (void)testChannelIsProvided {
//    MockParser *parser = MockParser.parser;
//    parser.channel = RSSFeeDataFactory.channel;
//    XCTestExpectation *expectation = [self expectationWithDescription:@"FeedChannel is provided"];
//    
//    [self.sut discoverChannel:RSSFeeDataFactory.rawData
//                       parser:parser
//                   completion:^(UVFeedChannel *channel, NSError *error) {
//        XCTAssertNotNil(channel);
//        XCTAssertTrue(parser.isCalled);
//        XCTAssertNil(error);
//        XCTAssertEqualObjects(parser.channel, channel);
//        [expectation fulfill];
//    }];
//    
//    [self waitForExpectations:@[expectation] timeout:1];
//}
//
//@end
