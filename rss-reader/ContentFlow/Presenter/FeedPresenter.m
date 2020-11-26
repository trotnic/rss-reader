//
//  FeedPresenter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedPresenter.h"
#import "FeedChannel.h"
#import "RouterType.h"

@interface FeedPresenter ()

@property (nonatomic, retain) FeedChannel *channel;
@property (nonatomic, assign) id<FeedViewType> view;
@property (nonatomic, retain) id<RouterType> router;
@property (nonatomic, retain) id<FeedProviderType> provider;

@end

@implementation FeedPresenter

// MARK: -

- (instancetype)initWithProvider:(id<FeedProviderType>)provider
                          router:(id<RouterType>)router
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
    [self.provider fetchData:^(FeedChannel *channel, NSError *error) {
        [weakSelf retain];
        if(error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view toggleActivityIndicator:NO];
                [self.router showNetworkActivityIndicator:NO];
                [weakSelf.router showError:error];
            });
            [weakSelf release];
            return;
        }
        weakSelf.channel = channel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view toggleActivityIndicator:NO];
            [self.router showNetworkActivityIndicator:NO];
            [weakSelf.view updatePresentation];
        });
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
