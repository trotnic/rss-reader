//
//  FeedPresenter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <UIKit/UIKit.h>
#import "UVFeedPresenter.h"
#import "UVFeedViewType.h"

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

@property (nonatomic, assign) UIApplication *application;
@property (nonatomic, assign) id<UVFeedViewType> view;

@end

@implementation UVFeedPresenter

// MARK: -


- (instancetype)initWithView:(id<UVFeedViewType>)view
                    provider:(id<UVFeedProviderType>)provider
                     network:(id<UVNetworkType>)network
{
    self = [super init];
    if (self) {
        _view = view;
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
    [self.view rotateActivityIndicator:YES];
    __block typeof(self)weakSelf = self;
    [self.network fetchDataFromURL:[NSURL URLWithString:kFeedURL]
                        completion:^(NSData *data, NSError *error) {
        if (error) {
            [weakSelf showError:RSSErrorTypeBadNetwork];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view rotateActivityIndicator:NO];
            });
            return;
        }
        [weakSelf discoverChannel:data];
    }];
}

- (void)openArticleAt:(NSInteger)row {
    [self.application openURL:[self urlForItemAt:row]
                      options:@{}
            completionHandler:^(BOOL success) {
        NSLog(@"%@", success ? @" is opened" : @" isn't opened");
    }];
}

- (id<UVFeedChannelViewModel>)viewModel {
    return self.channel;
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
            [weakSelf.view rotateActivityIndicator:NO];
            [weakSelf.view updatePresentation];
        });
    }];
}

- (NSURL *)urlForItemAt:(NSInteger)row {
    return [NSURL URLWithString:self.channel.items[row].link];
}

- (void)showError:(RSSError)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view presentError:[self provideErrorOfType:error]];
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

// MARK: - Lazy

- (UIApplication *)application {
    if(!_application) {
        _application = UIApplication.sharedApplication;
    }
    return _application;
}

@end
