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
@property (nonatomic, retain) id<FeedProviderType> provider;
@property (nonatomic, retain) id<RouterType> router;

@end

@implementation FeedPresenter

// MARK: -

- (instancetype)initWithProvider:(id<FeedProviderType>)provider router:(id<RouterType>)router
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

- (void)assignView:(id<FeedViewType>)view {
    _view = view;
}

// MARK: - FeedPresenterType

- (void)updateFeed {
    __weak typeof(self)weakSelf = self;
    [self.provider fetchData:^(FeedChannel *channel, NSError *error) {
        if(error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.router showError:error];
            });
            return;
        }
        weakSelf.channel = channel;
        [weakSelf.view setChannel:channel];
    }];
}

- (void)selectRowAt:(NSInteger)row {
    [self.router openURL:[NSURL URLWithString:self.channel.items[row].link]];
}

@end
