//
//  UVAppCoordinatorMock.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 25.02.21.
//

#import "UVAppCoordinatorMock.h"

@implementation UVAppCoordinatorMock

- (void)showPresentationBlock:(UVPresentationBlockType)block {
    self.isCalled = YES;
    self.providedType = block;
}

@end
