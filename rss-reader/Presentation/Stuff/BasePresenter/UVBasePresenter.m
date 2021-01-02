//
//  UVBasePresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import "UVBasePresenter.h"
#import "LocalConstants.h"
#import "UVErrorDomain.h"

@implementation UVBasePresenter

- (void)showError:(RSSError)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view presentError:[self provideErrorOfType:error]];
    });
}

// MARK: - Private

- (NSError *)provideErrorOfType:(RSSError)type {
    switch (type) {
        case RSSErrorTypeBadNetwork: {
            return [NSError errorWithDomain:UVPresentationErrorDomain
                                       code:UVRSSReaderErrorCodeKey userInfo:@{
                NSLocalizedFailureReasonErrorKey: NSLocalizedString(BAD_INTERNET_CONNECTION_TITLE, ""),
                NSLocalizedDescriptionKey: NSLocalizedString(BAD_INTERNET_CONNECTION_DESCRIPTION, "")
            }];
        }
        case RSSErrorTypeParsingError: {
            return [NSError errorWithDomain:UVPresentationErrorDomain
                                       code:UVRSSReaderErrorCodeKey userInfo:@{
                NSLocalizedFailureReasonErrorKey: NSLocalizedString(BAD_RSS_FEED_TITLE, ""),
                NSLocalizedDescriptionKey: NSLocalizedString(BAD_RSS_FEED_DESCRIPTION, "")
            }];
        }
    }
}

@end
