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
@property (nonatomic, strong, readonly) NSMutableArray<UVRSSFeedItem *> *feedItems;

@property (nonatomic, retain) NSUUID *uuid;

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
        self.sourceManager = source;
        self.network = network;
        _coordinator = coordinator;
        _feedManager = feed;
    }
    return self;
}

- (void)dealloc
{
    [_network unregisterObserver:NSStringFromClass([self class])];
    [_sourceManager unregisterObserver:NSStringFromClass([self class])];
}

// MARK: - Lazy Properties

- (NSUUID *)uuid {
    if (!_uuid) {
        _uuid = NSUUID.UUID;
    }
    return _uuid;
}

- (void)setNetwork:(id<UVNetworkType>)network {
    if (network != _network) {
        [_network unregisterObserver:self.uuid.UUIDString];
        _network = network;
        __block typeof(self)weakSelf = self;
        [_network registerObserver:self.uuid.UUIDString callback:^(BOOL isConnectionStable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isConnectionStable) {
                    [weakSelf updateFeed];
                } else {
                    [weakSelf.view setSettingsButtonActive:NO];
                    [weakSelf showError:RSSErrorTypeNoNetworkConnection];
                }
            });
        }];
    }
}

- (void)setSourceManager:(id<UVSourceManagerType>)sourceManager {
    if (sourceManager != _sourceManager) {
        [_sourceManager unregisterObserver:self.uuid.UUIDString];
        _sourceManager = sourceManager;
        __weak typeof(self)weakSelf = self;
        [_sourceManager registerObserver:self.uuid.UUIDString callback:^(BOOL isOk) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isOk) {
                    [weakSelf updateFeed];
                    [weakSelf.view updatePresentation];
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
    UVRSSFeedItem *item = self.feedItems[row];
    [self.feedManager setState:UVRSSItemReading ofFeedItem:item];
    [self.feedManager selectFeedItem:item];
    [self.coordinator showScreen:PresentationBlockWeb];
}

- (void)settingsButtonClicked {
    [self.coordinator showScreen:PresentationBlockSources];
}

- (void)trashButtonClicked {
    [self.coordinator showScreen:PresentationBlockDone];
}

- (id<UVFeedItemDisplayModel>)itemAt:(NSInteger)index {
    return self.feedItems[index];
}

- (NSInteger)numberOfItems {
    return self.feedItems.count;
}

- (void)markItemDoneAtIndex:(NSInteger)index {
    [self.feedManager setState:UVRSSItemDone ofFeedItem:self.feedItems[index]];
}

- (void)markItemReadAtIndex:(NSInteger)index {
    [self.feedManager setState:UVRSSItemReading ofFeedItem:self.feedItems[index]];
}

- (void)deleteItemAtIndex:(NSInteger)index {
    [self.feedManager setState:UVRSSItemDeleted ofFeedItem:self.feedItems[index]];
}

// MARK: - Private

- (NSMutableArray<UVRSSFeedItem *> *)feedItems {
    return [[self.feedManager feedItemsWithState:(UVRSSItemNotStarted | UVRSSItemReading)] mutableCopy];
}

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
