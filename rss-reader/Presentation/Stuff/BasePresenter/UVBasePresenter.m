//
//  UVBasePresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import "UVBasePresenter.h"
#import "LocalConstants.h"
#import "UVErrorDomain.h"

@interface UVBasePresenter ()

@property (nonatomic, retain, readwrite) id<UVDataRecognizerType> dataRecognizer;
@property (nonatomic, retain, readwrite) id<UVSourceManagerType> sourceManager;
@property (nonatomic, retain, readwrite) id<UVNetworkType> network;
@property (nonatomic, retain, readwrite) id<CoordinatorType> coordinator;

@end

@implementation UVBasePresenter

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                     sourceManager:(id<UVSourceManagerType>)manager
                           network:(id<UVNetworkType>)network
                       coordinator:(nonnull id<CoordinatorType>)coordinator
{
    self = [super init];
    if (self) {
        _dataRecognizer = recognizer;
        _sourceManager = manager;
        _network = network;
        _coordinator = coordinator;
    }
    return self;
}

- (void)showError:(RSSError)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewDelegate presentError:[self provideErrorOfType:error]];
    });
}

// MARK: - Private

- (NSError *)provideErrorOfType:(RSSError)type {
    switch (type) {
        case RSSErrorTypeNoNetworkConnection: {
            return [NSError errorWithDomain:UVPresentationErrorDomain code:UVRSSReaderErrorCodeKey userInfo:@{
                NSLocalizedFailureReasonErrorKey:   NSLocalizedString(NO_NETWORK_CONNECTION_TITLE, ""),
                NSLocalizedDescriptionKey:          NSLocalizedString(NO_NETWORK_CONNECTION_DESCRIPTION, "")
            }];
        }
        case RSSErrorTypeParsingError: {
            return [NSError errorWithDomain:UVPresentationErrorDomain code:UVRSSReaderErrorCodeKey userInfo:@{
                NSLocalizedFailureReasonErrorKey:   NSLocalizedString(BAD_RSS_FEED_TITLE, ""),
                NSLocalizedDescriptionKey:          NSLocalizedString(BAD_RSS_FEED_DESCRIPTION, "")
            }];
        }
        case RSSErrorTypeBadURL: {
            return [NSError errorWithDomain:UVPresentationErrorDomain code:UVRSSReaderErrorCodeKey userInfo:@{
                NSLocalizedFailureReasonErrorKey:   NSLocalizedString(BAD_URL_TITLE, ""),
                NSLocalizedDescriptionKey:          NSLocalizedString(BAD_URL_DESCRIPTION, "")
            }];
        }
        case RSSErrorNoRSSLinksDiscovered: {
            return [NSError errorWithDomain:UVPresentationErrorDomain code:UVRSSReaderErrorCodeKey userInfo:@{
                NSLocalizedFailureReasonErrorKey:   NSLocalizedString(NO_RSS_LINKS_DISCOVERED_TITLE, ""),
                NSLocalizedDescriptionKey:          NSLocalizedString(NO_RSS_LINKS_DISCOVERED_DESCRIPTION, "")
            }];
        }
        case RSSErrorNoRSSLinkSelected: {
            return [NSError errorWithDomain:UVPresentationErrorDomain code:UVRSSReaderErrorCodeKey userInfo:@{
                NSLocalizedFailureReasonErrorKey:   NSLocalizedString(NO_RSS_LINK_SELECTED_TITLE,""),
                NSLocalizedDescriptionKey:          NSLocalizedString(NO_RSS_LINK_SELECTED_DESCRIPTION, "")
            }];
        }
    }
}

@end
