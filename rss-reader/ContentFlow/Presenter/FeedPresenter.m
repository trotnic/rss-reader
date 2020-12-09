//
//  FeedPresenter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedPresenter.h"
#import "FeedChannel.h"
#import "FeedViewType.h"
#import "FeedProviderType.h"
#import <UIKit/UIKit.h>

@interface FeedPresenter ()

@property (nonatomic, retain) FeedChannel *channel;
@property (nonatomic, assign) id<FeedViewType> view;
@property (nonatomic, retain) id<FeedProviderType> provider;

@end

@implementation FeedPresenter

// MARK: -

- (instancetype)initWithProvider:(id<FeedProviderType>)provider
{
    self = [super init];
    if (self) {
        _provider = [provider retain];
    }
    return self;
}

- (void)dealloc
{
    [_channel release];
    [_provider release];
    [super dealloc];
}

// MARK: - FeedPresenterType

- (void)updateFeed {
    __block typeof(self)weakSelf = self;
    [self.provider fetchData:^(FeedChannel *channel, NSError *error) {
        if(error) {
            [weakSelf.view presentError:error];
            return;
        }
        weakSelf.channel = channel;
        [weakSelf.view updatePresentation];
    }];
}

- (void)selectRowAt:(NSInteger)row {
    NSURL *url = [NSURL URLWithString:self.channel.items[row].link];
    [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success) {
        NSLog(@"%@", success ? @"is opened" : @"isn't opened");
    }];
}

- (id<FeedChannelViewModel>)viewModel {
    return self.channel;
}

- (void)assignView:(id<FeedViewType>)view {
    _view = view;
}

@end
