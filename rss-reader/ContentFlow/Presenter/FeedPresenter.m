//
//  FeedPresenter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <UIKit/UIKit.h>
#import "FeedPresenter.h"
#import "FeedChannel.h"
#import "FeedViewType.h"
#import "FeedProviderType.h"
#import "ErrorManagerType.h"
#import "FeedXMLParser.h"

static NSString *const kFeedURL = @"https://news.tut.by/rss/index.rss";

@interface FeedPresenter ()

@property (nonatomic, retain) FeedChannel *channel;
@property (nonatomic, retain) id<FeedProviderType> provider;
@property (nonatomic, retain) id<ErrorManagerType> errorManager;
@property (nonatomic, retain) id<UVNetworkType> network;

@end

@implementation FeedPresenter

// MARK: -

- (instancetype)initWithProvider:(id<FeedProviderType>)provider
                    errorManager:(id<ErrorManagerType>)manager
                         network:(id<UVNetworkType>)network
{
    self = [super init];
    if (self) {
        _provider = [provider retain];
        _errorManager = [manager retain];
        _network = [network retain];
    }
    return self;
}

- (void)dealloc
{
    [_network release];
    [_channel release];
    [_provider release];
    [_errorManager release];
    [super dealloc];
}

// MARK: - FeedPresenterType

- (void)updateFeed {
    [self.view toggleActivityIndicator:YES];
    __block typeof(self)weakSelf = self;
    [self.network fetchDataFromURL:[NSURL URLWithString:kFeedURL]
                        completion:^(NSData *data, NSError *error) {
        if(error) {
            [weakSelf showError:RSSErrorTypeBadNetwork];
            return;;
        }
        [weakSelf.provider discoverChannel:data
                                    parser:[[FeedXMLParser new] autorelease]
                                completion:^(FeedChannel *channel, RSSError error) {
            if(error == RSSErrorTypeNone) {
                weakSelf.channel = channel;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.view toggleActivityIndicator:NO];
                    [weakSelf.view updatePresentation];
                });
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view toggleActivityIndicator:NO];
                [weakSelf showError:error];
            });
        }];
    }];
}

- (void)openArticleAt:(NSInteger)row {
    NSURL *url = [NSURL URLWithString:self.channel.items[row].link];
    [UIApplication.sharedApplication openURL:url
                                     options:@{}
                           completionHandler:^(BOOL success) {
        NSLog(@"%@ %@", url, success ? @" is opened" : @" isn't opened");
    }];
}

- (id<FeedChannelViewModel>)viewModel {
    return self.channel;
}

// MARK: - Private

- (void)showError:(RSSError)error {
    __weak typeof(self)weakSelf = self;
    [self.errorManager provideErrorOfType:error
                           completion:^(NSError *resultError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.view presentError:resultError];
        });
    }];
}

@end
