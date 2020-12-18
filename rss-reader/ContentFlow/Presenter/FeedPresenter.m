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
#import "UVDataRecognizer.h"
#import "NSURL+Util.h"

@interface FeedPresenter ()

@property (nonatomic, retain) FeedChannel *channel;
@property (nonatomic, assign) id<FeedViewType> view;
@property (nonatomic, retain) id<FeedProviderType> provider;
@property (nonatomic, retain) id<UVSourceManagerType> sourceManager;

@end

@implementation FeedPresenter

// MARK: -

- (instancetype)initWithProvider:(id<FeedProviderType>)provider
                   sourceManager:(id<UVSourceManagerType>)sourceManager
{
    self = [super init];
    if (self) {
        _provider = [provider retain];
        _sourceManager = [sourceManager retain];
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
    [self.view toggleActivityIndicator:YES];
    __block typeof(self)weakSelf = self;
    
    [self.provider fetchDataFromURL:[NSURL URLWithString:self.sourceManager.selectedLink.link]
                         completion:^(FeedChannel *channel, RSSError error) {
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
                    [weakSelf.view toggleActivityIndicator:NO];
                    [weakSelf.view presentError:[weakSelf provideErrorOfType:error]];
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
