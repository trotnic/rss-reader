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

@synthesize viewDelegate;

// MARK: -

- (void)dealloc
{
    [_channel release];
    [super dealloc];
}

// MARK: - UVChannelFeedPresenterType

- (void)updateFeed {
    [self.viewDelegate rotateActivityIndicator:YES];
    if (!self.sourceManager.links.count) {
        self.channel = nil;
        [self.viewDelegate clearState];
        [self showError:RSSErrorNoRSSLinkSelected];
        return;
    }
    
    NSURL *url = self.sourceManager.selectedLink.url;
    if (!url) {
        self.channel = nil;
        [self.viewDelegate clearState];
        [self showError:RSSErrorTypeBadURL];
        return;
    }
    
    __block typeof(self)weakSelf = self;
    [self.network fetchDataFromURL:url
                        completion:^(NSData *data, NSError *error) {
        if(error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.channel = nil;
                [self.viewDelegate clearState];
            });
            [weakSelf showError:RSSErrorNoRSSLinksDiscovered];
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
    [self.viewDelegate presentWebPageOnURL:url];
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
            [weakSelf showError:RSSErrorNoRSSLinksDiscovered];
            return;
        }
        
        weakSelf.channel = [UVFeedChannel objectWithDictionary:channel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.viewDelegate rotateActivityIndicator:NO];
            [weakSelf.viewDelegate updatePresentation];
        });
    }];
}

- (void)showError:(RSSError)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewDelegate rotateActivityIndicator:NO];
    });
    [super showError:error];
}

@end
