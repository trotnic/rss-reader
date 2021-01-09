//
//  UVFeedPresenterTests.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import <XCTest/XCTest.h>
#import "UVChannelFeedPresenter.h"
#import "UVNetworkMock.h"
#import "UVChannelFeedViewMock.h"
#import "UVDataRecognizerMock.h"
#import "UVSourceManagerMock.h"
#import "SwissKnife.h"
#import "RSSDataFactory.h"

static NSInteger const TIMEOUT = 4;

@interface UVChannelFeedPresenterTests : XCTestCase

@property (nonatomic, retain) UVChannelFeedPresenter *sut;
@property (nonatomic, retain) UVNetworkMock *network;
@property (nonatomic, retain) UVDataRecognizerMock *dataRecognizer;
@property (nonatomic, retain) UVSourceManagerMock *sourceManager;
@property (nonatomic, retain) UVChannelFeedViewMock *view;

@end

@implementation UVChannelFeedPresenterTests

- (void)setUp {
    _view = [UVChannelFeedViewMock new];
    _network = [UVNetworkMock new];
    _dataRecognizer = [UVDataRecognizerMock new];
    _sourceManager = [UVSourceManagerMock new];
    _sut = [[UVChannelFeedPresenter alloc] initWithRecognizer:self.dataRecognizer
                                                sourceManager:self.sourceManager
                                                      network:self.network];
    _sut.viewDelegate = self.view;
}

- (void)tearDown {
    [_network release];
}

- (void)testNoURLProvidedError {
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        return self.view.error != nil && !self.view.isActivityShown;
    }];
    
    [self.sut updateFeed];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
    
    XCTAssertFalse(self.dataRecognizer.isCalled);
    XCTAssertFalse(self.network.isCalled);
}

- (void)testNetworkErrorOccuredPresented {
    self.sourceManager.linkToReturn = [RSSDataFactory linkSelected:YES];
    self.network.requestError = SwissKnife.mockError;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        return self.view.error != nil && !self.view.isActivityShown;
    }];
    
    [self.sut updateFeed];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
    
    XCTAssertFalse(self.dataRecognizer.isCalled);
    XCTAssertTrue(self.network.isCalled);
}

- (void)testNilDataFromNetworkErrorPresented {
    self.sourceManager.linkToReturn = [RSSDataFactory linkSelected:YES];
    self.network.data = RSSDataFactory.rawDataNil;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        return self.view.error != nil && !self.view.isActivityShown;
    }];
    
    [self.sut updateFeed];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
    
    XCTAssertFalse(self.dataRecognizer.isCalled);
    XCTAssertTrue(self.network.isCalled);
}

- (void)testRecognitionErrorPresented {
    self.sourceManager.linkToReturn = [RSSDataFactory linkSelected:YES];
    self.network.data = RSSDataFactory.rawXMLData;
    self.dataRecognizer.error = SwissKnife.mockError;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        return self.view.error != nil && !self.view.isActivityShown;
    }];
    
    [self.sut updateFeed];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
    
    XCTAssertTrue(self.dataRecognizer.isCalled);
    XCTAssertTrue(self.network.isCalled);
}

- (void)testChannelNormallyPresented {
    UVFeedChannel *expected = RSSDataFactory.channel;
    self.sourceManager.linkToReturn = [RSSDataFactory linkSelected:YES];
    self.network.data = RSSDataFactory.rawXMLData;
    self.dataRecognizer.rawChannel = RSSDataFactory.rawChannel;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        return self.view.error == nil && !self.view.isActivityShown;
    }];
    
    [self.sut updateFeed];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
    
    XCTAssertTrue(self.dataRecognizer.isCalled);
    XCTAssertTrue(self.network.isCalled);
    XCTAssertEqualObjects(expected, [self.sut performSelector:@selector(channel)]);
}

@end
