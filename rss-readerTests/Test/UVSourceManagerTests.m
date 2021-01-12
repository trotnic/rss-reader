//
//  UVSourceManagerTests.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 9.01.21.
//

#import <XCTest/XCTest.h>
#import "UVSourceManager.h"
#import "UVPlistRepositoryMock.h"
#import "NSUserDefaultsMock.h"
#import "RSSDataFactory.h"
#import "SwissKnife.h"

@interface UVSourceManagerTests : XCTestCase

@property (nonatomic, retain) UVSourceManager *sut;
@property (nonatomic, retain) UVPlistRepositoryMock *repository;
@property (nonatomic, retain) NSUserDefaults *defaults;

@end

@implementation UVSourceManagerTests

- (void)setUp {
    _sut = [UVSourceManager new];
    _repository = [UVPlistRepositoryMock new];
    _defaults = [NSUserDefaultsMock new];
    
    [self.sut setValue:self.defaults forKey:@"userDefaults"];
    [self.sut setValue:self.repository forKey:@"repository"];
}

- (void)tearDown {
    [_sut release];
    [_repository release];
    [_defaults release];
}

- (void)testSourceObjectBuiltNormally {
    NSURL *url = SwissKnife.mockURL;
    NSArray *links = @[];
    RSSSource *expected = [RSSSource sourceWithURL:url links:links];
    
    RSSSource *obtained = [self.sut buildObjectWithURL:url links:links];
    
    XCTAssertEqualObjects(expected, obtained);
}

- (void)testEmptyLinksArrayObtainedNormally {
    NSArray *expected = [RSSDataFactory sourceNoLinksSelected:NO].rssLinks;
    NSArray *obtained = [self.sut links];
    
    XCTAssertEqualObjects(expected, obtained);
    XCTAssertEqual(expected.count, obtained.count);
}

- (void)testNoEmptyLinksArrayObtainedNormally {
    NSArray<RSSLink *> *expected = RSSDataFactory.sourceFromPlistSelectedNO.rssLinks;
    self.repository.fetchedToReturn = @[RSSDataFactory.rawSourceFromPlistSelectedNO];
    NSArray<RSSLink *> *obtained = self.sut.links;
    
    XCTAssertEqualObjects(expected, obtained);
    XCTAssertEqual(expected.count, obtained.count);
}

- (void)testAttemptToInsertObjectWithNilURLErrorOccures {
    NSError *error = nil;
    NSURL *url = nil;
    NSArray<NSDictionary *> *links = @[RSSDataFactory.rawLinkFromXML];
    BOOL isInserted = [self.sut insertSourceWithURL:url links:links error:&error];
    
    XCTAssertNotNil(error);
    XCTAssertFalse(isInserted);
}

- (void)testAttemptToInsertObjectWithNilLinksArrayErrorOccures {
    NSError *error = nil;
    NSURL *url = SwissKnife.mockURL;
    NSArray<NSDictionary *> *links = nil;
    BOOL isInserted = [self.sut insertSourceWithURL:url links:links error:&error];
    
    XCTAssertNotNil(error);
    XCTAssertFalse(isInserted);
}

- (void)testAttemptToInsertObjectWithEmptyLinksArrayErrorOccures {
    NSError *error = nil;
    NSURL *url = SwissKnife.mockURL;
    NSArray<NSDictionary *> *links = @[];
    BOOL isInserted = [self.sut insertSourceWithURL:url links:links error:&error];
    
    XCTAssertNotNil(error);
    XCTAssertFalse(isInserted);
}

- (void)testAttemptToInsertObjectWithWrongRawDataErrorOccures {
    NSError *error = nil;
    NSURL *url = SwissKnife.mockURL;
    NSArray *links = @[RSSDataFactory.rawGarbageData];
    BOOL isInserted = [self.sut insertSourceWithURL:url links:links error:&error];
    
    XCTAssertNotNil(error);
    XCTAssertFalse(isInserted);
}

- (void)testAttemptToInsertObjectWithCorrectUrlAndLinksNormally {
    RSSSource *expected = RSSDataFactory.sourceFromPlistSelectedNO;
    NSArray<NSDictionary *> *links = RSSDataFactory.rawLinksFromHTML;
    NSURL *url = expected.url;
    NSError *error = nil;
    BOOL isInserted = [self.sut insertSourceWithURL:url links:links error:&error];
    
    XCTAssertNil(error);
    XCTAssertTrue(isInserted);
}

- (void)testSavingInternalErrorOccuresProvided {
    NSError *error = nil;
    self.repository.fetchedToReturn = @[RSSDataFactory.rawSourceFromPlistSelectedNO];
    self.repository.updateErrorToReturn = SwissKnife.mockError;
    self.repository.updatedToReturn = NO;
    BOOL isSaved = [self.sut saveState:&error];
    
    XCTAssertNotNil(error);
    XCTAssertFalse(isSaved);
}

- (void)testSavingDataNormally {
    NSError *error = nil;
    self.repository.fetchedToReturn = @[RSSDataFactory.rawSourceFromPlistSelectedNO];
    self.repository.updatedToReturn = YES;
    BOOL isSaved = [self.sut saveState:&error];
    
    XCTAssertNil(error);
    XCTAssertTrue(isSaved);
    XCTAssertEqualObjects(self.repository.fetchedToReturn, self.repository.dataProvided);
}

@end
