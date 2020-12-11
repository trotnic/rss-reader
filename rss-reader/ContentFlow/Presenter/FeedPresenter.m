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

@interface FeedPresenter ()

@property (nonatomic, retain) FeedChannel *channel;
@property (nonatomic, assign) id<FeedViewType> view;
@property (nonatomic, retain) id<FeedProviderType> provider;
@property (nonatomic, retain) id<ErrorManagerType> errorManager;

@end

@implementation FeedPresenter

// MARK: -

- (instancetype)initWithProvider:(id<FeedProviderType>)provider
                    errorManager:(id<ErrorManagerType>)manager
{
    self = [super init];
    if (self) {
        _provider = [provider retain];
        _errorManager = [manager retain];
    }
    return self;
}

- (void)dealloc
{
    [_channel release];
    [_provider release];
    [_errorManager release];
    [super dealloc];
}

// MARK: - FeedPresenterType

- (void)updateFeed {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view toggleActivityIndicator:YES];
    });
    __block typeof(self)weakSelf = self;
    [self.provider fetchData:^(FeedChannel *channel, RSSError error) {
        switch (error) {
            case RSSErrorTypeNone: {
                weakSelf.channel = channel;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view toggleActivityIndicator:NO];
                    [weakSelf.view updatePresentation];
                });
                break;
            }
            default: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view toggleActivityIndicator:NO];
                    [weakSelf.errorManager provideErrorOfType:error withCompletion:^(NSError *resultError) {
                        [weakSelf.view presentError:resultError];
                    }];
                });
            }
        }
    }];
}

- (void)selectRowAt:(NSInteger)row {
    [self.view presentWebPageOnLink:self.channel.items[row].link];
}

- (id<FeedChannelViewModel>)viewModel {
    return self.channel;
}

- (void)assignView:(id<FeedViewType>)view {
    _view = view;
}

@end
