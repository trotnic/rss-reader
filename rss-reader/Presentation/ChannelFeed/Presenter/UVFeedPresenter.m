//
//  FeedPresenter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <UIKit/UIKit.h>
#import "UVFeedPresenter.h"
#import "UVFeedChannel.h"
#import "UVFeedViewType.h"
#import "UVFeedProviderType.h"
#import "UVFeedXMLParser.h"

static NSString *const kFeedURL = @"https://news.tut.by/rss/index.rss";

@interface UVFeedPresenter ()

@property (nonatomic, retain) UVFeedChannel *channel;
@property (nonatomic, retain) id<UVFeedProviderType> provider;
@property (nonatomic, retain) id<UVNetworkType> network;

@end

@implementation UVFeedPresenter

@synthesize view;

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
    [self.view rotateActivityIndicator:YES];
    __block typeof(self)weakSelf = self;
    [self.network fetchDataFromURL:[NSURL URLWithString:kFeedURL]
                        completion:^(NSData *data, NSError *error) {
        if(error) {
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
    [self.view presentWebPageOnURL:[self urlForItemAt:row]];
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

@end
