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

- (void)testInsertLinksUncontainedBySourceInsertionSuccessful {
    NSInteger initialSize = 0;
    NSArray<NSDictionary *> *expectedLinks = RSSDataFactory.rawLinksFromHTML;
    NSURL *url = SwissKnife.mockURL;
    self.repository.fetchedToReturn = @[];
    
    XCTAssertEqual(initialSize, self.sut.links.count);
    [self.sut insertLinks:expectedLinks relativeToURL:url];
    XCTAssertEqual(expectedLinks.count, self.sut.links.count);
}

- (void)testInsertLinkUncontainedBySourceInsertionSuccessful {
    NSInteger initialSize = 0;
    NSInteger expectedSize = 1;
    NSDictionary *link = RSSDataFactory.rawLinkFromXML;
    NSURL *url = SwissKnife.mockURL;
    self.repository.fetchedToReturn = @[];
    
    XCTAssertEqual(initialSize, self.sut.links.count);
    [self.sut insertLink:link relativeToURL:url];
    XCTAssertEqual(expectedSize, self.sut.links.count);
}

- (void)testDeleteLink {
    NSArray *links = RSSDataFactory.rawLinksFromHTML;
    RSSLink *link = [RSSDataFactory linkSelected:NO];
    NSInteger expectedSize = links.count - 1;
    self.repository.fetchedToReturn = links;
    
    XCTAssertEqual(links.count, self.sut.links.count);
    [self.sut deleteLink:link];
    XCTAssertEqual(expectedSize, self.sut.links.count);
}

- (void)testSelectLink {
    NSInteger indexToSelect = 0;
    NSArray *links = RSSDataFactory.rawLinksFromHTML;
    self.repository.fetchedToReturn = links;
    RSSLink *link = self.sut.links[indexToSelect];
    
    XCTAssertFalse(link.isSelected);
    [self.sut selectLink:link];
    XCTAssertTrue(link.isSelected);
}

- (void)testSelectedLinkEqualsToSelection {
    NSInteger indexToSelect = 0;
    NSArray *links = RSSDataFactory.rawLinksFromHTML;
    self.repository.fetchedToReturn = links;
    RSSLink *link = self.sut.links[indexToSelect];
    
    XCTAssertFalse(link.isSelected);
    [self.sut selectLink:link];
    XCTAssertTrue(link.isSelected);
    XCTAssertEqualObjects(link, self.sut.selectedLink);
}

- (void)testSelectedLinkEqualsToTheFirstLinkWhenNoSelectedByDefault {
    NSArray *links = RSSDataFactory.rawLinksFromHTML;
    self.repository.fetchedToReturn = links;
    RSSLink *link = self.sut.links.firstObject;
    
    XCTAssertFalse(link.isSelected);
    RSSLink *selectedLink = self.sut.selectedLink;
    XCTAssertEqualObjects(link, selectedLink);
    XCTAssertTrue(link.isSelected);
}

@end
