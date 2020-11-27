//
//  FeedPresenter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedPresenter.h"
#import "FeedChannel.h"
#import "MainRouter.h"

@interface FeedPresenter ()

@property (nonatomic, retain) FeedChannel *channel;
@property (nonatomic, assign) id<FeedViewType> view;
@property (nonatomic, retain) id<MainRouter> router;
@property (nonatomic, retain) id<FeedProviderType> provider;

@end

@implementation FeedPresenter

// MARK: -

- (instancetype)initWithProvider:(id<FeedProviderType>)provider
                          router:(id<MainRouter>)router
{
    self = [super init];
    if (self) {        
        _router = [router retain];
        _provider = [provider retain];
    }
    return self;
}

- (void)dealloc
{
    [_router release];
    [_channel release];
    [_provider release];
    [super dealloc];
}

// MARK: - FeedPresenterType

- (void)updateFeed {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view toggleActivityIndicator:YES];
        [self.router showNetworkActivityIndicator:YES];
    });
    __block typeof(self)weakSelf = self;
    [self.provider fetchData:^(FeedChannel *channel, RSSError error) {
        [weakSelf retain];
        switch (error) {
            case RSSErrorTypeNone: {
                weakSelf.channel = channel;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view toggleActivityIndicator:NO];
                    [self.router showNetworkActivityIndicator:NO];
                    [weakSelf.view updatePresentation];
                });
                break;
            }
            default: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view toggleActivityIndicator:NO];
                    [self.router showNetworkActivityIndicator:NO];
                    [weakSelf.router showErrorOfType:error];
                });
                [weakSelf release];
            }
        }
        [weakSelf release];
    }];
}

- (void)selectRowAt:(NSInteger)row {
    [self.router openURL:[NSURL URLWithString:self.channel.items[row].link]];
}

- (id<FeedChannelViewModel>)viewModel {
    return self.channel;
}

- (void)assignView:(id<FeedViewType>)view {
    _view = view;
}

@end
