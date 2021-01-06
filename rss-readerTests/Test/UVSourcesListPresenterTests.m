//
//  UVSourcesListPresenterTests.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 5.01.21.
//

#import <XCTest/XCTest.h>
#import "UVSourcesListPresenter.h"
#import "UVNetworkMock.h"
#import "UVSourcesListViewMock.h"
#import "UVDataRecognizerMock.h"
#import "UVSourceManagerMock.h"
#import "SwissKnife.h"
#import "RSSDataFactory.h"

@interface UVSourcesListPresenterTests : XCTestCase

@property (nonatomic, retain) UVSourcesListPresenter *sut;
@property (nonatomic, retain) UVNetworkMock *network;
@property (nonatomic, retain) UVDataRecognizerMock *dataRecognizer;
@property (nonatomic, retain) UVSourceManagerMock *sourceManager;
@property (nonatomic, retain) UVSourcesListViewMock *view;

@end

@implementation UVSourcesListPresenterTests

- (void)setUp {
    _view = [UVSourcesListViewMock new];
    _network = [UVNetworkMock new];
    _dataRecognizer = [UVDataRecognizerMock new];
    _sourceManager = [UVSourceManagerMock new];
    _sut = [[UVSourcesListPresenter alloc] initWithRecognizer:self.dataRecognizer
                                                sourceManager:self.sourceManager
                                                      network:self.network];
    _sut.viewDelegate = self.view;
}

- (void)tearDown {
    [_network release];
    [_dataRecognizer release];
    
}

- (void)testInvalidAddressErrorPresented {
    self.network.validationError = SwissKnife.mockError;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        return !self.view.isUpdate && self.view.error != nil;
    }];
    
    [self.sut discoverAddress:@""];
    
    [self waitForExpectations:@[expectation] timeout:2];
    
    XCTAssertTrue(self.network.isCalled);
    XCTAssertFalse(self.dataRecognizer.isCalled);
    XCTAssertFalse(self.sourceManager.isCalled);
}

- (void)testNilValidatedURLProvidedErrorPresented {
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        return !self.view.isUpdate && self.view.error != nil;
    }];
    
    [self.sut discoverAddress:@""];
    
    [self waitForExpectations:@[expectation] timeout:2];
    
    XCTAssertTrue(self.network.isCalled);
    XCTAssertFalse(self.dataRecognizer.isCalled);
    XCTAssertFalse(self.sourceManager.isCalled);
}

- (void)testNetworkErrorPresented {
    self.network.url = SwissKnife.mockURL;
    self.network.requestError = SwissKnife.mockError;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        return !self.view.isUpdate && self.view.error != nil;
    }];
    
    [self.sut discoverAddress:@""];
    
    [self waitForExpectations:@[expectation] timeout:2];
    
    XCTAssertTrue(self.network.isCalled);
    XCTAssertFalse(self.dataRecognizer.isCalled);
    XCTAssertFalse(self.sourceManager.isCalled);
}

- (void)testNilDataFromNetworkErrorPresented {
    self.network.url = SwissKnife.mockURL;
    self.network.data = RSSDataFactory.rawDataNil;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        return !self.view.isUpdate && self.view.error != nil;
    }];
    
    [self.sut discoverAddress:@""];
    
    [self waitForExpectations:@[expectation] timeout:2];
    
    XCTAssertTrue(self.network.isCalled);
    XCTAssertFalse(self.dataRecognizer.isCalled);
    XCTAssertFalse(self.sourceManager.isCalled);
}

- (void)testRecognitionErrorPresented {
    self.network.url = SwissKnife.mockURL;
    self.network.data = RSSDataFactory.rawData;
    self.dataRecognizer.error = SwissKnife.mockError;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        return !self.view.isUpdate && self.view.error != nil;
    }];
    
    [self.sut discoverAddress:@""];
    
    [self waitForExpectations:@[expectation] timeout:2];
    
    XCTAssertTrue(self.network.isCalled);
    XCTAssertTrue(self.dataRecognizer.isCalled);
    XCTAssertFalse(self.sourceManager.isCalled);
}

- (void)testInsertionErrorPresented {
    self.network.url = SwissKnife.mockURL;
    self.network.data = RSSDataFactory.rawData;
    self.sourceManager.insertionError = SwissKnife.mockError;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        return !self.view.isUpdate && self.view.error != nil;
    }];
    
    [self.sut discoverAddress:@""];
    
    [self waitForExpectations:@[expectation] timeout:2];
    
    XCTAssertTrue(self.network.isCalled);
    XCTAssertTrue(self.dataRecognizer.isCalled);
    XCTAssertTrue(self.sourceManager.isCalled);
    XCTAssertEqualObjects(self.sourceManager.providedURL, self.network.url);
}

- (void)testSavingErrorOccured {
    self.network.url = SwissKnife.mockURL;
    self.network.data = RSSDataFactory.rawData;
    self.sourceManager.savingError = SwissKnife.mockError;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        return !self.view.isUpdate;
    }];
    
    [self.sut discoverAddress:@""];
    
    [self waitForExpectations:@[expectation] timeout:2];
    
    XCTAssertTrue(self.network.isCalled);
    XCTAssertTrue(self.dataRecognizer.isCalled);
    XCTAssertTrue(self.sourceManager.isCalled);
    XCTAssertEqualObjects(self.sourceManager.providedURL, self.network.url);
}

- (void)testNewLinksProvidedNormally {
    self.network.url = SwissKnife.mockURL;
    self.network.data = RSSDataFactory.rawData;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        return !self.view.error && self.view.isUpdate;
    }];
    
    [self.sut discoverAddress:@""];
    
    [self waitForExpectations:@[expectation] timeout:2];
    
    XCTAssertTrue(self.network.isCalled);
    XCTAssertTrue(self.dataRecognizer.isCalled);
    XCTAssertTrue(self.sourceManager.isCalled);
    XCTAssertEqualObjects(self.sourceManager.providedURL, self.network.url);
}

@end
