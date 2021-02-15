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

@property (nonatomic, retain) id<UVFeedManagerType> feed;

@end

@implementation UVChannelFeedPresenter

@synthesize viewDelegate;

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                            source:(id<UVSourceManagerType>)source
                           network:(id<UVNetworkType>)network
                              feed:(id<UVFeedManagerType>)feed
                       coordinator:(id<UVCoordinatorType>)coordinator {
    self = [super initWithRecognizer:recognizer source:source
                             network:network coordinator:coordinator];
    if (self) {
        _feed = feed;
    }
    return self;
}

// MARK: - UVChannelFeedPresenterType

- (void)updateFeed {
    if (!self.network.isConnectionAvailable) {
        [self.viewDelegate setSettingsButtonActive:NO];
        [self showError:RSSErrorTypeNoNetworkConnection];
        return;
    }
    [self.viewDelegate rotateActivityIndicator:YES];
    if (!self.sourceManager.links.count) {
        [self.viewDelegate clearState];
        [self showError:RSSErrorNoRSSLinkSelected];
        return;
    }
    
    NSURL *url = self.sourceManager.selectedLink.url;
    if (!url) {
        [self.viewDelegate clearState];
        [self showError:RSSErrorTypeBadURL];
        return;
    }
    
    __block typeof(self)weakSelf = self;
    [self.network fetchDataFromURL:url
                        completion:^(NSData *data, NSError *error) {
        if(error) {
            [weakSelf showError:RSSErrorNoRSSLinksDiscovered];
            return;
        }
        [weakSelf discoverChannel:data];
    }];
}

- (void)openArticleAt:(NSInteger)row {
    [self.feed selectItem:self.feed.channelFeed.items[row]];
    [self.coordinator showScreen:PresentationBlockWeb];
}

- (void)settingsButtonClicked {
    [self.coordinator showScreen:PresentationBlockSources];
}

- (id<UVFeedChannelDisplayModel>)channel {
    return self.feed.channelFeed;
}

// MARK: - Private

- (void)discoverChannel:(NSData *)data {
    if(!data) {
        [self showError:RSSErrorTypeParsingError];
        return;
    }
    __block typeof(self)weakSelf = self;
    [self.dataRecognizer discoverChannel:data parser:[UVFeedXMLParser new]
                              completion:^(NSDictionary *channel, NSError *error) {
        if(error) {
            [weakSelf showError:RSSErrorNoRSSLinksDiscovered];
            return;
        }
        
        NSError *feedError = nil;
        [weakSelf.feed provideRawFeed:channel error:&feedError];
        if (error) {
            [weakSelf showError:RSSErrorTypeBadURL];
            return;
        }
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
