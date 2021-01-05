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
    _sut.view = _view;
}

- (void)tearDown {
    [_network release];
}

- (void)testNoURLProvidedError {
    [self.sut updateFeed];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        XCTAssertFalse(self.view.isActivityShown);
        XCTAssertNotNil(self.view.error);
        XCTAssertTrue(self.view.isCalled);
    });
    
    XCTAssertFalse(self.dataRecognizer.isCalled);
    XCTAssertFalse(self.network.isCalled);
}

- (void)testNetworkErrorOccuredPresented {
    self.sourceManager.linkToReturn = [RSSDataFactory linkSelected:YES];
    self.network.error = SwissKnife.mockError;
    [self.sut updateFeed];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        XCTAssertFalse(self.view.isActivityShown);
        XCTAssertNotNil(self.view.error);
        XCTAssertTrue(self.view.isCalled);
    });
    
    XCTAssertFalse(self.dataRecognizer.isCalled);
    XCTAssertTrue(self.network.isCalled);
}

- (void)testNilDataFromNetworkErrorPresented {
    self.sourceManager.linkToReturn = [RSSDataFactory linkSelected:YES];
    self.network.data = RSSDataFactory.rawDataNil;
    [self.sut updateFeed];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        XCTAssertFalse(self.view.isActivityShown);
        XCTAssertNotNil(self.view.error);
        XCTAssertTrue(self.view.isCalled);
    });
    
    XCTAssertFalse(self.dataRecognizer.isCalled);
    XCTAssertTrue(self.network.isCalled);
}

- (void)testRecognitionErrorPresented {
    self.sourceManager.linkToReturn = [RSSDataFactory linkSelected:YES];
    self.network.data = RSSDataFactory.rawData;
    self.dataRecognizer.error = SwissKnife.mockError;
    [self.sut updateFeed];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        XCTAssertFalse(self.view.isActivityShown);
        XCTAssertNotNil(self.view.error);
        XCTAssertTrue(self.view.isCalled);
    });
    
    XCTAssertTrue(self.dataRecognizer.isCalled);
    XCTAssertTrue(self.network.isCalled);
}

- (void)testChannelNormallyPresented {
    UVFeedChannel *expected = RSSDataFactory.channel;
    self.sourceManager.linkToReturn = [RSSDataFactory linkSelected:YES];
    self.network.data = RSSDataFactory.rawData;
    self.dataRecognizer.rawChannel = RSSDataFactory.rawChannel;
    [self.sut updateFeed];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        XCTAssertNil(self.view.error);
        XCTAssertFalse(self.view.isActivityShown);
        XCTAssertTrue(self.view.isCalled);
    });
    
    XCTAssertTrue(self.dataRecognizer.isCalled);
    XCTAssertTrue(self.network.isCalled);
    XCTAssertEqualObjects(expected, [self.sut performSelector:@selector(channel)]);
}

@end
