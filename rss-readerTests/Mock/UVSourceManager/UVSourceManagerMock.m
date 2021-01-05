//
//  UVSourceManagerMock.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 3.01.21.
//

#import "UVSourceManagerMock.h"

@interface UVSourceManagerMock ()

@end

@implementation UVSourceManagerMock

@synthesize links;


- (RSSSource *)buildObjectWithURL:(NSURL *)url
                            links:(NSArray<RSSLink *> *)links {
    self.isCalled = YES;
    return self.sourceToReturn;
}

- (void)insertObject:(RSSSource *)source {
    self.isCalled = YES;
    [self.sourcesToReturn addObject:source];
}

- (void)removeObject:(nonnull RSSSource *)source {
    self.isCalled = YES;
    [self.sourcesToReturn removeObject:source];
}

- (BOOL)saveState:(out NSError **)error {
    self.isCalled = YES;
    *error = self.errorToReturn;
    return YES;
}

- (void)selectLink:(RSSLink *)link {
    self.isCalled = YES;
}

- (RSSLink *)selectedLink {
    self.isCalled = YES;
    return self.linkToReturn;
}

- (RSSSource *)selectedSource {
    self.isCalled = YES;
    return self.sourceToReturn;
}

- (void)updateObject:(RSSSource *)source {
    self.isCalled = YES;
}

@end
