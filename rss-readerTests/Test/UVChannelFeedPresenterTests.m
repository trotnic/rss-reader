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

@property (nonatomic, strong) UVChannelFeedPresenter *sut;
@property (nonatomic, strong) UVNetworkMock *network;
@property (nonatomic, strong) UVDataRecognizerMock *dataRecognizer;
@property (nonatomic, strong) UVSourceManagerMock *sourceManager;
@property (nonatomic, strong) UVChannelFeedViewMock *view;

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

- (void)testNoSelectedLinkProvidedErrorOccuredPresented {
    self.sourceManager.linksToReturn = RSSDataFactory.linksEmptyList;
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.sourceManager.isCalled);
        XCTAssertFalse(self.dataRecognizer.isCalled);
        XCTAssertFalse(self.network.isCalled);
        return self.view.error != nil && !self.view.isActivityShown;
    }];
    
    [self.sut updateFeed];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testNoURLProvidedErrorOccuredPresented {
    RSSLink *link = nil;
    self.sourceManager.linksToReturn = RSSDataFactory.links;
    self.sourceManager.selectedLinkToReturn = link;
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.sourceManager.isCalled);
        XCTAssertFalse(self.dataRecognizer.isCalled);
        XCTAssertFalse(self.network.isCalled);
        return self.view.error != nil && !self.view.isActivityShown;
    }];
    
    [self.sut updateFeed];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testNetworkErrorOccuredPresented {
    self.sourceManager.linksToReturn = RSSDataFactory.links;
    self.sourceManager.selectedLinkToReturn = [RSSDataFactory linkSelected:YES];
    self.network.requestError = SwissKnife.mockError;

    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.sourceManager.isCalled);
        XCTAssertFalse(self.dataRecognizer.isCalled);
        XCTAssertTrue(self.network.isCalled);
        return self.view.error != nil && !self.view.isActivityShown;
    }];

    [self.sut updateFeed];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testNilDataFromNetworkErrorPresented {
    self.sourceManager.linksToReturn = RSSDataFactory.links;
    self.sourceManager.selectedLinkToReturn = [RSSDataFactory linkSelected:YES];
    self.network.data = RSSDataFactory.rawDataNil;

    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.sourceManager.isCalled);
        XCTAssertFalse(self.dataRecognizer.isCalled);
        XCTAssertTrue(self.network.isCalled);
        return self.view.error != nil && !self.view.isActivityShown;
    }];

    [self.sut updateFeed];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testRecognitionErrorOccuredPresented {
    self.sourceManager.linksToReturn = RSSDataFactory.links;
    self.sourceManager.selectedLinkToReturn = [RSSDataFactory linkSelected:YES];
    self.network.data = RSSDataFactory.rawXMLData;
    self.dataRecognizer.discoverChannelErrorToReturn = SwissKnife.mockError;

    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.sourceManager.isCalled);
        XCTAssertTrue(self.dataRecognizer.isCalled);
        XCTAssertTrue(self.network.isCalled);
        return self.view.error != nil && !self.view.isActivityShown;
    }];

    [self.sut updateFeed];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testChannelNormallyPresented {
    UVFeedChannel *expected = RSSDataFactory.channel;
    self.sourceManager.linksToReturn = RSSDataFactory.links;
    self.sourceManager.selectedLinkToReturn = [RSSDataFactory linkSelected:YES];
    self.network.data = RSSDataFactory.rawXMLData;
    self.dataRecognizer.rawChannelToReturn = RSSDataFactory.rawChannel;

    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.dataRecognizer.isCalled);
        XCTAssertTrue(self.network.isCalled);
        XCTAssertEqualObjects(expected, [self.sut performSelector:@selector(channel)]);
        return self.view.error == nil && !self.view.isActivityShown;
    }];

    [self.sut updateFeed];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testAttemptToOpenArticleWithNilURLErrorOccuredProvided {
//    UVFeedChannel *channel = RSSDataFactory.channel;
    UVFeedChannel *channel = nil;
    NSInteger index = 0;
    [self.sut setValue:channel forKey:@"channel"];
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertFalse(self.sourceManager.isCalled);
        XCTAssertFalse(self.dataRecognizer.isCalled);
        XCTAssertFalse(self.network.isCalled);
        XCTAssertNil(self.view.presentedURL);
        return self.view.error != nil && !self.view.isActivityShown;
    }];
    
    [self.sut openArticleAt:index];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testAttemptToOpenArticleNormally {
    UVFeedChannel *channel = RSSDataFactory.channel;
    NSInteger index = 0;
    [self.sut setValue:channel forKey:@"channel"];
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertFalse(self.sourceManager.isCalled);
        XCTAssertFalse(self.dataRecognizer.isCalled);
        XCTAssertFalse(self.network.isCalled);
        XCTAssertNotNil(self.view.presentedURL);
        XCTAssertEqualObjects(channel.items[index].url, self.view.presentedURL);
        return self.view.error == nil && !self.view.isActivityShown;
    }];
    
    [self.sut openArticleAt:index];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}


@end
