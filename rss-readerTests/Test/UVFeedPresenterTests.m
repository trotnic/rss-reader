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
#import "UIApplicationMock.h"

static NSInteger const TIMEOUT = 2;

@interface UVFeedPresenterTests : XCTestCase

@property (nonatomic, retain) UVFeedPresenter *sut;
@property (nonatomic, retain) UVNetworkMock *network;
@property (nonatomic, retain) UVFeedProviderMock *provider;
@property (nonatomic, retain) UVFeedViewMock *view;
@property (nonatomic, assign) UIApplicationMock *application;

@end

@implementation UVFeedPresenterTests

- (void)setUp {
    _view = [UVFeedViewMock new];
    _network = [UVNetworkMock new];
    _provider = [UVFeedProviderMock new];
    _sut = [[UVFeedPresenter alloc] initWithProvider:self.provider network:self.network];
    _sut.viewDelegate = self.view;
    _application = [UIApplicationMock new];
}

- (void)tearDown {
    [_network release];
    [_provider release];
    [_application release];
}

- (void)testNetworkErrorOccuredPresented {
    self.network.error = SwissKnife.mockError;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.network.isCalled);
        XCTAssertFalse(self.provider.isCalled);
        XCTAssertNotNil(self.view.error);
        XCTAssertFalse(self.view.isActivityShown);
        return YES;
    }];
    
    [self.sut updateFeed];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testNilDataErrorPresented {
    NSData *rawData = nil;
    self.network.data = rawData;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.network.isCalled);
        XCTAssertFalse(self.provider.isCalled);
        XCTAssertNotNil(self.view.error);
        XCTAssertFalse(self.view.isActivityShown);
        return YES;
    }];
    
    [self.sut updateFeed];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testProviderErrorPresented {
    self.network.data = RSSFeeDataFactory.rawData;
    self.provider.error = SwissKnife.mockError;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.network.isCalled);
        XCTAssertTrue(self.provider.isCalled);
        XCTAssertNotNil(self.view.error);
        XCTAssertFalse(self.view.isActivityShown);
        return YES;
    }];
    
    [self.sut updateFeed];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testChannelIsPresented {
    self.network.data = RSSFeeDataFactory.rawData;
    self.provider.channel = RSSFeeDataFactory.channel;
    [self.sut updateFeed];
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"channel != nil"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.network.isCalled);
        XCTAssertTrue(self.provider.isCalled);
        XCTAssertFalse(self.view.isActivityShown);
        XCTAssertNil(self.view.error);
        return [self.view.channel isEqual:self.provider.channel];
    }];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testArticleIsPresentedForSafari {
    
    UVFeedChannel *channel = RSSFeeDataFactory.channel;
    NSURL *expectedURL = [NSURL URLWithString:channel.items[0].link];
    [self.sut performSelector:@selector(setChannel:) withObject:channel];
    [self.sut setValue:self.application forKey:@"application"];
    [self.sut openArticleAt:0];
    
    XCTAssertEqualObjects(self.application.selectedURL, expectedURL);
    XCTAssertTrue(self.application.isCalled);
}

@end
