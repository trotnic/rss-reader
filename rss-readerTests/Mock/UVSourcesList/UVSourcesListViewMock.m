//
//  UVSourcesListViewMock.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 6.01.21.
//

#import "UVSourcesListViewMock.h"

@interface UVSourcesListViewMock ()

@end

@implementation UVSourcesListViewMock

- (void)updatePresentation {
    self.isCalled = YES;
}

- (void)stopSearchWithUpdate:(BOOL)update {
    self.isCalled = YES;
    self.isUpdate = update;
}

- (void)presentError:(NSError *)error {
    self.isCalled = YES;
    self.error = error;
}

@end
