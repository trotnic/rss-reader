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

- (void)removeObject:(nonnull RSSSource *)source {
    self.isCalled = YES;
    [self.sourcesToReturn removeObject:source];
}

- (BOOL)saveState:(out NSError **)error {
    self.isCalled = YES;
    if (error) {
        *error = self.savingError;
    }
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

- (BOOL)insertSourceWithURL:(nonnull NSURL *)url
                      links:(nonnull NSArray<NSDictionary *> *)links
                      error:(out NSError * _Nullable * _Nullable)error {
    self.isCalled = YES;
    self.providedURL = url;
    self.providedLinks = links;
    if (error) {
        *error = self.insertionError;
    }
    return self.validationResultToReturn;
}


@end
