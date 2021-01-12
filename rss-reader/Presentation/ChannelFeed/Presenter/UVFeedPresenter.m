//
//  FeedPresenter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "UVFeedPresenter.h"

#import "UVFeedChannel.h"
#import "UVFeedXMLParser.h"

#import "RSSError.h"
#import "LocalConstants.h"
#import "UVErrorDomain.h"

static NSString *const kFeedURL = @"https://news.tut.by/rss/index.rss";

@interface UVFeedPresenter ()

@property (nonatomic, retain) UVFeedChannel *channel;
@property (nonatomic, retain) id<UVFeedProviderType> provider;
@property (nonatomic, retain) id<UVNetworkType> network;

@end

@implementation UVFeedPresenter

// MARK: -

- (instancetype)initWithProvider:(id<UVFeedProviderType>)provider
                         network:(id<UVNetworkType>)network
{
    self = [super init];
    if (self) {
        _provider = [provider retain];
        _network = [network retain];
    }
    return self;
}

- (void)dealloc
{
    [_network release];
    [_channel release];
    [_provider release];
    [super dealloc];
}

// MARK: - FeedPresenterType

- (void)updateFeed {
    [self.viewDelegate rotateActivityIndicator:YES];
    __block typeof(self)weakSelf = self;
    [self.network fetchDataFromURL:[NSURL URLWithString:kFeedURL]
                        completion:^(NSData *data, NSError *error) {
        if (error) {
            [weakSelf showError:RSSErrorTypeBadNetwork];
            return;
        }
        [weakSelf discoverChannel:data];
    }];
}

- (void)openArticleAt:(NSInteger)row {
    [self.viewDelegate presentWebPageOnURL:[self urlForItemAt:row]];
}

// MARK: - Private

- (void)discoverChannel:(NSData *)data {
    if(!data) {
        [self showError:RSSErrorTypeParsingError];
        return;
    }
    __block typeof(self)weakSelf = self;
    [self.provider discoverChannel:data
                            parser:[[UVFeedXMLParser new] autorelease]
                        completion:^(UVFeedChannel *channel, NSError *error) {
        if(error) {
            [weakSelf showError:RSSErrorTypeParsingError];
            return;
        }
        weakSelf.channel = channel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.viewDelegate rotateActivityIndicator:NO];
            [weakSelf.viewDelegate updatePresentationWithChannel:weakSelf.channel];
        });
    }];
}

- (NSURL *)urlForItemAt:(NSInteger)row {
    return [NSURL URLWithString:self.channel.items[row].link];
}

- (void)showError:(RSSError)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewDelegate rotateActivityIndicator:NO];
        [self.viewDelegate presentError:[self provideErrorOfType:error]];
    });
}

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
