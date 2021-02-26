//
//  UVChannelFeedPresenter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "UVChannelFeedPresenter.h"
#import "UVChannelFeedViewType.h"
#import "UVFeedXMLParser.h"
#import "UVRSSFeed.h"

@interface UVChannelFeedPresenter ()

@property (nonatomic, strong) id<UVDataRecognizerType>  dataRecognizer;
@property (nonatomic, strong) id<UVSourceManagerType>   sourceManager;
@property (nonatomic, strong) id<UVNetworkType>         network;
@property (nonatomic, strong) id<UVCoordinatorType>     coordinator;
@property (nonatomic, strong) id<UVFeedManagerType>     feedManager;

@end

@implementation UVChannelFeedPresenter

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                            source:(id<UVSourceManagerType>)source
                           network:(id<UVNetworkType>)network
                              feed:(id<UVFeedManagerType>)feed
                       coordinator:(id<UVCoordinatorType>)coordinator {
    self = [super init];
    if (self) {
        _dataRecognizer = recognizer;
        _sourceManager = source;
        self.network = network;
        _coordinator = coordinator;
        _feedManager = feed;
    }
    return self;
}

- (void)dealloc
{
    [self.network unregisterObserver:NSStringFromClass([self class])];
}

// MARK: -

- (void)setNetwork:(id<UVNetworkType>)network {
    if (network != _network) {
        [_network unregisterObserver:NSStringFromClass([self class])];
        _network = network;
        __block typeof(self)weakSelf = self;
        [_network registerObserver:NSStringFromClass([self class]) callback:^(BOOL isConnectionStable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isConnectionStable) {
                    [self updateFeed];
                } else {
                    [self.view setSettingsButtonActive:NO];
                    [weakSelf showError:RSSErrorTypeNoNetworkConnection];
                }
            });
        }];
    }
}

// MARK: - UVChannelFeedPresenterType

- (void)updateFeed {
    if (!self.network.isConnectionAvailable) {
        [self.view setSettingsButtonActive:NO];
        [self.view updatePresentation];
        [self showError:RSSErrorTypeNoNetworkConnection];
        return;
    }
    [self.view setSettingsButtonActive:YES];
    [self.view rotateActivityIndicator:YES];
    if (!self.sourceManager.links.count) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
            [self.feedManager deleteFeed];
        });
        [self.view clearState];
        [self showError:RSSErrorNoRSSLinkSelected];
        return;
    }
    
    NSURL *url = self.sourceManager.selectedLink.url;
    if (!url) {
        [self.view clearState];
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
    if (!self.network.isConnectionAvailable) {
        [self.view setSettingsButtonActive:NO];
        [self showError:RSSErrorTypeNoNetworkConnection];
        return;
    }
    [self.feedManager selectFeedItem:self.feedManager.feed.items[row]];
    [self.coordinator showScreen:PresentationBlockWeb];
}

- (void)settingsButtonClicked {
    [self.coordinator showScreen:PresentationBlockSources];
}

- (id<UVFeedChannelDisplayModel>)channel {
    return self.feedManager.feed;
}

// MARK: - Private

- (void)discoverChannel:(NSData *)data {
    if(!data) {
        [self showError:RSSErrorTypeParsingError];
        return;
    }
    __weak typeof(self)weakSelf = self;
    [self.dataRecognizer discoverChannel:data parser:[UVFeedXMLParser new]
                              completion:^(NSDictionary *channel, NSError *error) {
        if(error) {
            [weakSelf showError:RSSErrorNoRSSLinksDiscovered];
            return;
        }
        
        NSError *feedError = nil;
        if (![weakSelf.feedManager storeFeed:channel error:&feedError]) {
            [weakSelf showError:RSSErrorTypeBadURL];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.view rotateActivityIndicator:NO];
            [weakSelf.view updatePresentation];
        });
    }];
}

- (void)showError:(RSSError)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view presentError:[UVChannelFeedPresenter provideErrorOfType:error]];
    });
}

@end
