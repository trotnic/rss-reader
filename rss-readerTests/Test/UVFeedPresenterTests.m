//
//  UVFeedPresenterTests.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import <XCTest/XCTest.h>
#import "UVFeedPresenter.h"
#import "UVFeedProviderMock.h"
#import "UVNetworkMock.h"
#import "UVFeedViewMock.h"
#import "SwissKnife.h"
#import "RSSFeeDataFactory.h"

@interface UVFeedPresenterTests : XCTestCase

@property (nonatomic, retain) UVFeedPresenter *sut;
@property (nonatomic, retain) UVNetworkMock *network;
@property (nonatomic, retain) UVFeedProviderMock *provider;
@property (nonatomic, retain) UVFeedViewMock *view;

@end

@implementation UVFeedPresenterTests

- (void)setUp {
    _view = [UVFeedViewMock new];
    _network = [UVNetworkMock new];
    _provider = [UVFeedProviderMock new];
    _sut = [[UVFeedPresenter alloc] initWithProvider:self.provider network:self.network];
    _sut.viewDelegate = self.view;
}

- (void)tearDown {
    [_network release];
    [_provider release];
}

- (void)testNetworkErrorOccuredPresented {
    self.network.error = SwissKnife.mockError;
    [self.sut updateFeed];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        XCTAssertFalse(self.view.isActivityShown);
        XCTAssertNotNil(self.view.error);
        XCTAssertTrue(self.view.isCalled);
    });
    
    XCTAssertTrue(self.network.isCalled);
    XCTAssertFalse(self.provider.isCalled);
}

- (void)testNilDataErrorPresented {
    NSData *rawData = nil;
    self.network.data = rawData;
    [self.sut updateFeed];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        XCTAssertFalse(self.view.isActivityShown);
        XCTAssertNotNil(self.view.error);
        XCTAssertTrue(self.view.isCalled);
    });
    
    XCTAssertTrue(self.network.isCalled);
    XCTAssertFalse(self.provider.isCalled);
}

- (void)testProviderErrorPresented {
    self.network.data = RSSFeeDataFactory.rawData;
    self.provider.error = SwissKnife.mockError;
    [self.sut updateFeed];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        XCTAssertFalse(self.view.isActivityShown);
        XCTAssertNotNil(self.view.error);
        XCTAssertTrue(self.view.isCalled);
    });
    
    XCTAssertTrue(self.network.isCalled);
    XCTAssertTrue(self.provider.isCalled);
}

- (void)testChannelIsPresented {
    self.network.data = RSSFeeDataFactory.rawData;
    self.provider.channel = RSSFeeDataFactory.channel;
    [self.sut updateFeed];
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"channel != nil"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        return self.view.channel == self.provider.channel;
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        XCTAssertFalse(self.view.isActivityShown);
        XCTAssertNil(self.view.error);
        XCTAssertTrue(self.view.isCalled);
    });
    
    [self waitForExpectations:@[expectation] timeout:2];
    
    XCTAssertTrue(self.network.isCalled);
    XCTAssertTrue(self.provider.isCalled);
}

- (void)testArticleIsPresentedForSafari {
    UVFeedChannel *channel = RSSFeeDataFactory.channel;
    NSURL *expectedURL = [NSURL URLWithString:channel.items[0].link];
    [self.sut performSelector:@selector(setChannel:) withObject:channel];
    [self.sut openArticleAt:0];
    
    XCTAssertEqualObjects(self.view.presentedURL, expectedURL);
    XCTAssertTrue(self.view.isCalled);
}

@end
