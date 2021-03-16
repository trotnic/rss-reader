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
#import "UVAppCoordinatorMock.h"

static NSInteger const TIMEOUT = 4;

@interface UVSourcesListPresenterTests : XCTestCase

@property (nonatomic, retain) UVSourcesListPresenter *sut;
@property (nonatomic, retain) UVNetworkMock *network;
@property (nonatomic, retain) UVDataRecognizerMock *dataRecognizer;
@property (nonatomic, retain) UVSourceManagerMock *sourceManager;
@property (nonatomic, retain) UVAppCoordinatorMock *coordinator;
@property (nonatomic, retain) UVSourcesListViewMock *view;

@end

@implementation UVSourcesListPresenterTests

- (void)setUp {
    _view = [UVSourcesListViewMock new];
    _network = [UVNetworkMock new];
    _dataRecognizer = [UVDataRecognizerMock new];
    _sourceManager = [UVSourceManagerMock new];
    _coordinator = [UVAppCoordinatorMock new];
    _sut = [[UVSourcesListPresenter alloc] initWithRecognizer:self.dataRecognizer
                                                sourceManager:self.sourceManager
                                                      network:self.network
                                                  coordinator:self.coordinator];
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
        XCTAssertTrue(self.network.isCalled);
        XCTAssertFalse(self.dataRecognizer.isCalled);
        XCTAssertFalse(self.sourceManager.isCalled);
        return !self.view.isUpdate && self.view.error != nil;
    }];
    
    [self.sut discoverAddress:@""];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testNilValidatedURLProvidedErrorPresented {
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.network.isCalled);
        XCTAssertFalse(self.dataRecognizer.isCalled);
        XCTAssertFalse(self.sourceManager.isCalled);
        return !self.view.isUpdate && self.view.error != nil;
    }];

    [self.sut discoverAddress:@""];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testNetworkErrorPresented {
    self.network.url = SwissKnife.mockURL;
    self.network.requestError = SwissKnife.mockError;

    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.network.isCalled);
        XCTAssertFalse(self.dataRecognizer.isCalled);
        XCTAssertFalse(self.sourceManager.isCalled);
        return !self.view.isUpdate && self.view.error != nil;
    }];

    [self.sut discoverAddress:@""];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testNilDataFromNetworkErrorPresented {
    self.network.url = SwissKnife.mockURL;
    self.network.data = RSSDataFactory.rawDataNil;

    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.network.isCalled);
        XCTAssertFalse(self.dataRecognizer.isCalled);
        XCTAssertFalse(self.sourceManager.isCalled);
        return !self.view.isUpdate && self.view.error != nil;
    }];

    [self.sut discoverAddress:@""];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testHTMLDataRecognitionErrorOccuredPresented {
    self.network.url = SwissKnife.mockURL;
    self.network.data = RSSDataFactory.rawHTMLData;
    self.dataRecognizer.contentTypeToReturn = UVRawContentHTML;
    self.dataRecognizer.discoverHTMLErrorToReturn = SwissKnife.mockError;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        
        XCTAssertTrue(self.network.isCalled);
        XCTAssertTrue(self.dataRecognizer.isCalled);
        XCTAssertFalse(self.sourceManager.isCalled);
        return !self.view.isUpdate && self.view.error != nil;
    }];
    
    [self.sut discoverAddress:@"tut.by"];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testHTMLDataRecognizedNormally {
    self.network.url = SwissKnife.mockURL;
    self.network.data = RSSDataFactory.rawHTMLData;
    self.dataRecognizer.contentTypeToReturn = UVRawContentHTML;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.network.isCalled);
        XCTAssertTrue(self.dataRecognizer.isCalled);
        XCTAssertTrue(self.sourceManager.isCalled);
        return self.view.isUpdate && self.view.error == nil;
    }];
    
    [self.sut discoverAddress:@"tut.by"];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testXMLDataRecognitionErrorOccuredPresented {
    self.network.url = SwissKnife.mockURL;
    self.network.data = RSSDataFactory.rawXMLData;
    self.dataRecognizer.contentTypeToReturn = UVRawContentXML;
    self.dataRecognizer.discoverXMLErrorToReturn = SwissKnife.mockError;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.network.isCalled);
        XCTAssertTrue(self.dataRecognizer.isCalled);
        XCTAssertFalse(self.sourceManager.isCalled);
        XCTAssertEqualObjects(self.network.url, self.dataRecognizer.providedURL);
        return !self.view.isUpdate && self.view.error != nil;
    }];
    
    [self.sut discoverAddress:@"tut.by"];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testXMLDataRecognizedNormally {
    self.network.url = SwissKnife.mockURL;
    self.network.data = RSSDataFactory.rawXMLData;
    self.dataRecognizer.contentTypeToReturn = UVRawContentXML;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.network.isCalled);
        XCTAssertTrue(self.dataRecognizer.isCalled);
        XCTAssertTrue(self.sourceManager.isCalled);
        XCTAssertEqualObjects(self.network.url, self.dataRecognizer.providedURL);
        return self.view.isUpdate && self.view.error == nil;
    }];
    
    [self.sut discoverAddress:@"tut.by"];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testContentTypeDiscoverErrorOccuredPresented {
    self.network.url = SwissKnife.mockURL;
    self.network.data = RSSDataFactory.rawXMLData;
    self.dataRecognizer.discoverContentErrorToReturn = SwissKnife.mockError;
    self.dataRecognizer.contentTypeToReturn = UVRawContentUndefined;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.network.isCalled);
        XCTAssertTrue(self.dataRecognizer.isCalled);
        XCTAssertFalse(self.sourceManager.isCalled);
        return !self.view.isUpdate && self.view.error != nil;
    }];
    
    [self.sut discoverAddress:@"tut.by"];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testContentTypeUndefinedTypeOccuredAlertPresented {
    self.network.url = SwissKnife.mockURL;
    self.network.data = RSSDataFactory.rawXMLData;
    self.dataRecognizer.contentTypeToReturn = UVRawContentUndefined;
    self.dataRecognizer.discoverContentErrorToReturn = SwissKnife.mockError;
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        XCTAssertTrue(self.network.isCalled);
        XCTAssertTrue(self.dataRecognizer.isCalled);
        XCTAssertFalse(self.sourceManager.isCalled);
        return !self.view.isUpdate && self.view.error != nil;
    }];
    
    [self.sut discoverAddress:@"tut.by"];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testEmptyInitialLinksListReturnedNormally {
    NSArray *expected = RSSDataFactory.linksEmptyList;
    self.sourceManager.linksToReturn = expected;
    NSArray *obtained = self.sut.items;
    
    XCTAssertEqualObjects(expected, obtained);
    XCTAssertTrue(self.sourceManager.isCalled);
}

- (void)testInitialLinksListReturnedNormally {
    NSArray *expected = RSSDataFactory.links;
    self.sourceManager.linksToReturn = expected;
    NSArray *obtained = self.sut.items;
    
    XCTAssertEqualObjects(expected, obtained);
    XCTAssertTrue(self.sourceManager.isCalled);
}

- (void)testSelectionItemAtIndexItemIsSelectedNormally {
    NSInteger indexToSelect = 0;
    self.sourceManager.linksToReturn = RSSDataFactory.links;
    RSSLink *expected = self.sourceManager.linksToReturn[indexToSelect];
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        RSSLink *obtained = self.sourceManager.providedLinkToSelect;
        return [expected isEqual:obtained];
    }];
    
    [self.sut selectItemAtIndex:indexToSelect];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

- (void)testDeletionItemAtIndexItemIsSelectedNormally {
    NSInteger indexToDelete = 0;
    self.sourceManager.linksToReturn = RSSDataFactory.links;
    RSSLink *expected = self.sourceManager.linksToReturn[indexToDelete];
    
    XCTestExpectation *expectation = [self expectationForPredicate:[NSPredicate predicateWithFormat:@"isCalled == YES"]
                                               evaluatedWithObject:self.view
                                                           handler:^BOOL{
        RSSLink *obtained = self.sourceManager.providedLinkToDelete;
        return [expected isEqual:obtained];
    }];
    
    [self.sut deleteItemAtIndex:indexToDelete];

    [self waitForExpectations:@[expectation] timeout:TIMEOUT];
}

@end
