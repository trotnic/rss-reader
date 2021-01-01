//
//  ErrorManager.m
//  rss-reader
//
//  Created by Uladzislau on 11/25/20.
//

#import "ErrorManager.h"

NSInteger const RSSReaderErrorCodeKey = 10000;
NSString *const RSSReaderDomainKey = @"com.rss-reader.uvolchyk";

@implementation ErrorManager

- (void)provideErrorOfType:(RSSError)type
                completion:(ErrorCompletion)completion {
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
