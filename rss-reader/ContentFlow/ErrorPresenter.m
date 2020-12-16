//
//  ErrorPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 16.12.20.
//

#import "ErrorPresenter.h"

NSInteger const RSSReaderErrorCodeKey = 10000;
NSString *const RSSReaderDomainKey = @"com.rss-reader.uvolchyk";

@interface ErrorPresenter ()

@end

@implementation ErrorPresenter

- (void)provideErrorOfType:(RSSError)type
            withCompletion:(ErrorCompletion)completion {
    assert(completion);
    switch (type) {
        case RSSErrorTypeBadNetwork: {
            NSError *error = [NSError errorWithDomain:RSSReaderDomainKey code:RSSReaderErrorCodeKey userInfo:@{
                NSLocalizedFailureReasonErrorKey: NSLocalizedString(BAD_INTERNET_CONNECTION_TITLE, ""),
                NSLocalizedDescriptionKey: NSLocalizedString(BAD_INTERNET_CONNECTION_DESCRIPTION, "")
            }];
            completion(error);
            break;
        }
            
        case RSSErrorTypeParsingError: {
            NSError *error = [NSError errorWithDomain:RSSReaderDomainKey code:RSSReaderErrorCodeKey userInfo:@{
                NSLocalizedFailureReasonErrorKey: NSLocalizedString(BAD_RSS_FEED_TITLE, ""),
                NSLocalizedDescriptionKey: NSLocalizedString(BAD_RSS_FEED_DESCRIPTION, "")
            }];
            completion(error);
            break;
        }
        case RSSErrorTypeNone:
            break;
    }
}

@end
