//
//  UVFeedViewMock.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import "UVFeedViewMock.h"

@implementation UVFeedViewMock

- (void)presentError:(NSError *)error {
    self.isCalled = YES;
    self.error = error;
}

- (void)rotateActivityIndicator:(BOOL)show {
    self.isCalled = YES;
    self.isActivityShown = show;
}

- (void)presentWebPageOnURL:(NSURL *)url {
    self.isCalled = YES;
    self.presentedURL = url;
}

- (void)updatePresentationWithChannel:(id<UVFeedChannelDisplayModel>)channel {
    self.isCalled = YES;
    self.channel = channel;
}

@end
