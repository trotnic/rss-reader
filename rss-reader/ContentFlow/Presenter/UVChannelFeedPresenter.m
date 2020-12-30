//
//  FeedPresenter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <UIKit/UIKit.h>
#import "UVChannelFeedPresenter.h"
#import "FeedChannel.h"
#import "UVChannelFeedViewType.h"
#import "UVDataRecognizer.h"
#import "FeedXMLParser.h"
#import "UVNetwork.h"

@interface UVChannelFeedPresenter ()

@property (nonatomic, retain) FeedChannel *channel;

@end

@implementation UVChannelFeedPresenter

// MARK: -

- (void)dealloc
{
    [_channel release];
    [super dealloc];
}

// MARK: - FeedPresenterType

- (void)updateFeed {
    [self.view toggleActivityIndicator:YES];
    NSURL *url = [self buildURL];
    if (!url) {
        [self.view presentError:[self provideErrorOfType:RSSErrorTypeBadURL]];
        return;
    }
    __block typeof(self)weakSelf = self;
    [self.network fetchDataOnURL:url.absoluteURL
                      completion:^(NSData *data, NSError *error) {
        if(error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view toggleActivityIndicator:NO];
                [weakSelf.view presentError:[weakSelf provideErrorOfType:RSSErrorNoRSSLinks]];
            });
            return;
        }
        [weakSelf.dataRecognizer discoverChannel:data parser:FeedXMLParser.parser
                                      completion:^(FeedChannel *channel, RSSError error) {
            switch (error) {
                case RSSErrorTypeNone: {
                    weakSelf.channel = channel;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.view toggleActivityIndicator:NO];
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
    }];
}

- (void)showDetailAt:(NSInteger)row {
    [self.view presentWebPageOnLink:self.channel.items[row].link];
}

- (id<FeedChannelViewModel>)viewModel {
    return self.channel;
}

// MARK: - Private

- (NSURL *)buildURL {
    return [NSURL URLWithString:self.sourceManager.selectedLink.link
                  relativeToURL:self.sourceManager.selectedSource.url];
}

@end
