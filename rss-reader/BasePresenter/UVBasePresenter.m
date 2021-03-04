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
@property (nonatomic, retain) id<UVNetworkType> network;
@property (nonatomic, retain) id<UVAppCoordinatorType> coordinator;

@end

@implementation UVBasePresenter

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                     sourceManager:(id<UVSourceManagerType>)manager
                           network:(id<UVNetworkType>)network
                       coordinator:(id<UVAppCoordinatorType>)coordinator
{
    self = [super init];
    if (self) {
        _dataRecognizer = [recognizer retain];
        _sourceManager = [manager retain];
        _network = [network retain];
        _coordinator = [coordinator retain];
    }
    return self;
}

- (void)dealloc
{
    [_dataRecognizer release];
    [_sourceManager release];
    [_network release];
    [_coordinator release];
    [super dealloc];
}

// MARK: - Private

- (NSError *)provideErrorOfType:(RSSError)type {
    switch (type) {
        case RSSErrorTypeBadNetwork: {
            return [NSError errorWithDomain:UVPresentationErrorDomain code:UVRSSReaderErrorCodeKey userInfo:@{
                NSLocalizedFailureReasonErrorKey: NSLocalizedString(BAD_INTERNET_CONNECTION_TITLE, ""),
                NSLocalizedDescriptionKey: NSLocalizedString(BAD_INTERNET_CONNECTION_DESCRIPTION, "")
            }];
        }
        case RSSErrorTypeParsingError: {
            return [NSError errorWithDomain:UVPresentationErrorDomain code:UVRSSReaderErrorCodeKey userInfo:@{
                NSLocalizedFailureReasonErrorKey: NSLocalizedString(BAD_RSS_FEED_TITLE, ""),
                NSLocalizedDescriptionKey: NSLocalizedString(BAD_RSS_FEED_DESCRIPTION, "")
            }];
        }
        case RSSErrorTypeBadURL: {
            return [NSError errorWithDomain:UVPresentationErrorDomain code:UVRSSReaderErrorCodeKey userInfo:@{
                NSLocalizedFailureReasonErrorKey: NSLocalizedString(BAD_URL_TITLE, ""),
                NSLocalizedDescriptionKey: NSLocalizedString(BAD_URL_DESCRIPTION, "")
            }];
        }
        case RSSErrorNoRSSLinksDiscovered: {
            return [NSError errorWithDomain:UVPresentationErrorDomain code:UVRSSReaderErrorCodeKey userInfo:@{
                NSLocalizedFailureReasonErrorKey: NSLocalizedString(NO_RSS_LINKS_DISCOVERED_TITLE, ""),
                NSLocalizedDescriptionKey: NSLocalizedString(NO_RSS_LINKS_DISCOVERED_DESCRIPTION, "")
            }];
        }
        case RSSErrorNoRSSLinkSelected: {
            return [NSError errorWithDomain:UVPresentationErrorDomain code:UVRSSReaderErrorCodeKey userInfo:@{
                NSLocalizedFailureReasonErrorKey: NSLocalizedString(NO_RSS_LINK_SELECTED_TITLE,""),
                NSLocalizedDescriptionKey: NSLocalizedString(NO_RSS_LINK_SELECTED_DESCRIPTION, "")
            }];
        }
    }
}

@end
