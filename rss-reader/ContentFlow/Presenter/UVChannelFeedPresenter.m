//
//  UVChannelFeedPresenter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "UVChannelFeedPresenter.h"
#import "UVChannelFeedViewType.h"
#import "UVFeedXMLParser.h"
#import "UVFeedChannel.h"

@interface UVChannelFeedPresenter ()

@property (nonatomic, retain) UVFeedChannel *channel;

@end

@implementation UVChannelFeedPresenter

@synthesize view;

// MARK: -

- (void)dealloc
{
    [_channel release];
    [super dealloc];
}

// MARK: - UVChannelFeedPresenterType

- (void)updateFeed {
    [self.view rotateActivityIndicator:YES];
    NSURL *url = self.sourceManager.selectedLink.url;
    if (!url) {
        [self.view rotateActivityIndicator:NO];
        [self showError:RSSErrorTypeBadURL];
        return;
    }
    __block typeof(self)weakSelf = self;
    [self.network fetchDataFromURL:url
                        completion:^(NSData *data, NSError *error) {
        if(error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view rotateActivityIndicator:NO];
                [weakSelf showError:RSSErrorNoRSSLinks];
            });
            return;
        }
        [weakSelf discoverChannel:data];
    }];
}

- (void)openArticleAt:(NSInteger)row {
    NSURL *url = self.channel.items[row].url;
    if (!url) {
        [self showError:RSSErrorTypeBadURL];
        return;
    }
    [self.view presentWebPageOnURL:url];
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
    [self.dataRecognizer discoverChannel:data parser:[[UVFeedXMLParser new] autorelease]
                              completion:^(NSDictionary *channel, NSError *error) {
        if(error) {
            [weakSelf showError:RSSErrorNoRSSLinks];
            return;
        }
        
        weakSelf.channel = [UVFeedChannel objectWithDictionary:channel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.view rotateActivityIndicator:NO];
            [weakSelf.view updatePresentation];
        });
    }];
}

@end
